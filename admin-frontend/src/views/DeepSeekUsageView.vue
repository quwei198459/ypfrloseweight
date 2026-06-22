<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { ElMessage } from 'element-plus'
import {
  fetchDeepSeekUsageLogs,
  fetchDeepSeekUsageSummary,
  fetchAiCostSummary,
  fetchApiPrices,
  updateApiPrice,
} from '../api/admin'
import type { AiCostSummary, ApiPriceConfig, DeepSeekUsageLog, DeepSeekUsageSummary } from '../types/admin'

const FEATURE_LABELS: Record<string, string> = {
  food: '食物识别',
  skin: '皮肤检测',
  tcm: '中医体检',
}
function featureLabel(f: string) {
  return FEATURE_LABELS[f] || f || '-'
}

function fmtDate(d: Date) {
  const y = d.getFullYear()
  const m = String(d.getMonth() + 1).padStart(2, '0')
  const da = String(d.getDate()).padStart(2, '0')
  return `${y}-${m}-${da}`
}
function monthStart() {
  const d = new Date()
  d.setDate(1)
  return fmtDate(d)
}
function today() {
  return fmtDate(new Date())
}

const range = ref<[string, string]>([monthStart(), today()])
const logFeature = ref('')
const loading = ref(false)
const summary = ref<DeepSeekUsageSummary | null>(null)
const logs = ref<DeepSeekUsageLog[]>([])
const aiCost = ref<AiCostSummary | null>(null)
const prices = ref<ApiPriceConfig[]>([])
const savingPriceId = ref<number | null>(null)

function money4(n: number | null | undefined) {
  return '¥' + (Number(n) || 0).toFixed(4)
}
function money2(n: number | null | undefined) {
  return '¥' + (Number(n) || 0).toFixed(2)
}
function num(n: number | null | undefined) {
  return (Number(n) || 0).toLocaleString('zh-CN')
}

const totalCost = computed(() => Number(summary.value?.totalCostCny) || 0)
const maxDailyCost = computed(() => {
  const d = summary.value?.daily || []
  return d.reduce((m, x) => Math.max(m, Number(x.costCny) || 0), 0) || 1
})
function pctOfTotal(cost: number | null | undefined) {
  if (totalCost.value <= 0) return 0
  return Math.round(((Number(cost) || 0) / totalCost.value) * 1000) / 10
}
function userLabel(row: { nickname: string | null; phone: string | null; userId: number }) {
  return row.nickname || row.phone || `用户#${row.userId}`
}

const maxDailyTotal = computed(() => {
  const d = aiCost.value?.daily || []
  return d.reduce((m, x) => Math.max(m, Number(x.totalCostCny) || 0), 0) || 1
})

async function load() {
  loading.value = true
  try {
    const [from, to] = range.value || []
    const base = { from, to }
    const [s, l, ac, pc] = await Promise.all([
      fetchDeepSeekUsageSummary(base),
      fetchDeepSeekUsageLogs({ ...base, feature: logFeature.value || undefined, limit: 200 }),
      fetchAiCostSummary(base),
      fetchApiPrices(),
    ])
    summary.value = s
    logs.value = l
    aiCost.value = ac
    prices.value = pc
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载失败')
  } finally {
    loading.value = false
  }
}

async function savePrice(row: ApiPriceConfig) {
  savingPriceId.value = row.id
  try {
    await updateApiPrice(row.id, {
      unitPriceCny: Number(row.unitPriceCny) || 0,
      unitsPerCall: Number(row.unitsPerCall) || 1,
      freeQuota: Number(row.freeQuota) || 0,
      freeUntil: row.freeUntil || null,
      enabled: row.enabled ? 1 : 0,
      remark: row.remark || '',
    })
    ElMessage.success(`已更新「${row.displayName}」单价`)
    await load()
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '保存失败')
  } finally {
    savingPriceId.value = null
  }
}

onMounted(load)
</script>

<template>
  <div v-loading="loading" class="usage">
    <div class="usage__head">
      <div>
        <h1 class="usage__h1">AI 与接口费用</h1>
        <p class="usage__sub">统一统计每个功能的总成本 = 第三方接口费 + DeepSeek 大模型费。接口费按调用次数 × 可配置单价计算，DeepSeek 费按官方单价实时折算。</p>
      </div>
      <div class="usage__filters">
        <el-date-picker
          v-model="range"
          type="daterange"
          value-format="YYYY-MM-DD"
          range-separator="至"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
          :clearable="false"
          @change="load"
        />
        <el-button type="primary" :loading="loading" @click="load">查询</el-button>
      </div>
    </div>

    <!-- 统一总成本卡片 -->
    <el-row :gutter="16" class="usage__cards">
      <el-col :xs="24" :sm="8">
        <el-card class="card card--cost" shadow="never">
          <div class="card__label">总成本（接口 + DeepSeek）</div>
          <div class="card__value">{{ money2(aiCost?.totalCostCny) }}</div>
          <div class="card__hint">{{ aiCost?.from }} ~ {{ aiCost?.to }}</div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="8">
        <el-card class="card" shadow="never">
          <div class="card__label">第三方接口费</div>
          <div class="card__value card__value--vendor">{{ money2(aiCost?.vendorCostCny) }}</div>
          <div class="card__hint">食物识别 / 皮肤检测 / 舌诊</div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="8">
        <el-card class="card" shadow="never">
          <div class="card__label">DeepSeek 大模型费</div>
          <div class="card__value card__value--ds">{{ money2(aiCost?.deepseekCostCny) }}</div>
          <div class="card__hint">综合 / 分项分析</div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 按功能成本总览 -->
    <el-card class="block" shadow="never">
      <template #header><span class="block__title">按功能成本总览</span></template>
      <el-table :data="aiCost?.byFeature || []" size="small" empty-text="暂无数据">
        <el-table-column label="功能" min-width="100">
          <template #default="{ row }">{{ row.displayName }}</template>
        </el-table-column>
        <el-table-column label="接口调用(成功/总)" align="right" min-width="140">
          <template #default="{ row }">{{ num(row.vendorSuccessCalls) }} / {{ num(row.vendorCalls) }}</template>
        </el-table-column>
        <el-table-column label="接口费" align="right" min-width="100">
          <template #default="{ row }">{{ money4(row.vendorCostCny) }}</template>
        </el-table-column>
        <el-table-column label="DeepSeek 调用" align="right" min-width="120">
          <template #default="{ row }">{{ num(row.deepseekCalls) }}</template>
        </el-table-column>
        <el-table-column label="DeepSeek 费" align="right" min-width="110">
          <template #default="{ row }">{{ money4(row.deepseekCostCny) }}</template>
        </el-table-column>
        <el-table-column label="合计成本" align="right" min-width="110">
          <template #default="{ row }">
            <strong class="cost-strong">{{ money4(row.totalCostCny) }}</strong>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 第三方接口单价配置 -->
    <el-card class="block" shadow="never">
      <template #header>
        <span class="block__title">第三方接口单价配置</span>
        <span class="block__hint-inline">单次费用 = 单价 × 每次单元数；命中免费额度则计 0。改完点「保存」即时生效。</span>
      </template>
      <el-table :data="prices" size="small" empty-text="暂无配置">
        <el-table-column label="接口" min-width="130">
          <template #default="{ row }">
            <div>{{ row.displayName }}</div>
            <div class="price__provider">{{ row.provider }}</div>
          </template>
        </el-table-column>
        <el-table-column label="单价(元/单元)" width="150">
          <template #default="{ row }">
            <el-input-number v-model="row.unitPriceCny" :min="0" :step="0.001" :precision="6" size="small" controls-position="right" style="width: 130px" />
          </template>
        </el-table-column>
        <el-table-column label="每次单元数" width="120">
          <template #default="{ row }">
            <el-input-number v-model="row.unitsPerCall" :min="0" :step="1" size="small" controls-position="right" style="width: 100px" />
          </template>
        </el-table-column>
        <el-table-column label="单次费用" align="right" width="100">
          <template #default="{ row }">{{ money4((Number(row.unitPriceCny) || 0) * (Number(row.unitsPerCall) || 0)) }}</template>
        </el-table-column>
        <el-table-column label="免费额度" width="120">
          <template #default="{ row }">
            <el-input-number v-model="row.freeQuota" :min="0" :step="1" size="small" controls-position="right" style="width: 100px" />
          </template>
        </el-table-column>
        <el-table-column label="免费截止" width="160">
          <template #default="{ row }">
            <el-date-picker v-model="row.freeUntil" type="date" value-format="YYYY-MM-DD" placeholder="无" clearable size="small" style="width: 140px" />
          </template>
        </el-table-column>
        <el-table-column label="计费" width="70" align="center">
          <template #default="{ row }">
            <el-switch v-model="row.enabled" :active-value="1" :inactive-value="0" size="small" />
          </template>
        </el-table-column>
        <el-table-column label="操作" width="90" align="center">
          <template #default="{ row }">
            <el-button type="primary" link size="small" :loading="savingPriceId === row.id" @click="savePrice(row)">保存</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 按供应商 -->
    <el-card class="block" shadow="never">
      <template #header><span class="block__title">按第三方供应商</span></template>
      <el-table :data="aiCost?.byProvider || []" size="small" empty-text="暂无数据">
        <el-table-column label="供应商" min-width="130">
          <template #default="{ row }">{{ row.displayName }}</template>
        </el-table-column>
        <el-table-column label="调用次数" align="right">
          <template #default="{ row }">{{ num(row.calls) }}</template>
        </el-table-column>
        <el-table-column label="成功" align="right">
          <template #default="{ row }">{{ num(row.successCalls) }}</template>
        </el-table-column>
        <el-table-column label="命中免费" align="right">
          <template #default="{ row }">{{ num(row.freeCalls) }}</template>
        </el-table-column>
        <el-table-column label="费用" align="right">
          <template #default="{ row }">{{ money4(row.costCny) }}</template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 每日费用趋势（接口 + DeepSeek） -->
    <el-card class="block" shadow="never">
      <template #header><span class="block__title">每日费用趋势（接口 + DeepSeek）</span></template>
      <div v-if="(aiCost?.daily?.length || 0) === 0" class="block__empty">暂无数据</div>
      <div v-else class="trend">
        <div v-for="d in aiCost?.daily || []" :key="d.date" class="trend__row">
          <span class="trend__date">{{ d.date }}</span>
          <div class="trend__bar-wrap">
            <div class="trend__bar" :style="{ width: ((Number(d.totalCostCny) / maxDailyTotal) * 100).toFixed(1) + '%' }" />
          </div>
          <span class="trend__cost">{{ money4(d.totalCostCny) }}</span>
          <span class="trend__calls">接口 {{ money4(d.vendorCostCny) }}</span>
        </div>
      </div>
    </el-card>

    <el-divider content-position="left">DeepSeek 明细</el-divider>

    <!-- 汇总卡片 -->
    <el-row :gutter="16" class="usage__cards">
      <el-col :xs="24" :sm="8">
        <el-card class="card card--cost" shadow="never">
          <div class="card__label">DeepSeek 费用</div>
          <div class="card__value">{{ money2(summary?.totalCostCny) }}</div>
          <div class="card__hint">{{ summary?.from }} ~ {{ summary?.to }}</div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="8">
        <el-card class="card card--calls" shadow="never">
          <div class="card__label">总调用次数</div>
          <div class="card__value">{{ num(summary?.totalCalls) }}</div>
          <div class="card__hint">皮肤每次检测约 7 次调用</div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="8">
        <el-card class="card card--tokens" shadow="never">
          <div class="card__label">总 Tokens</div>
          <div class="card__value">{{ num(summary?.totalTokens) }}</div>
          <div class="card__hint">输入 + 输出合计</div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="16">
      <!-- 按功能 -->
      <el-col :xs="24" :md="12">
        <el-card class="block" shadow="never">
          <template #header><span class="block__title">按功能</span></template>
          <el-table :data="summary?.byFeature || []" size="small" empty-text="暂无数据">
            <el-table-column label="功能">
              <template #default="{ row }">{{ featureLabel(row.feature) }}</template>
            </el-table-column>
            <el-table-column label="调用次数" align="right">
              <template #default="{ row }">{{ num(row.calls) }}</template>
            </el-table-column>
            <el-table-column label="Tokens" align="right">
              <template #default="{ row }">{{ num(row.tokens) }}</template>
            </el-table-column>
            <el-table-column label="费用" align="right">
              <template #default="{ row }">{{ money4(row.costCny) }}</template>
            </el-table-column>
            <el-table-column label="占比" align="right" width="80">
              <template #default="{ row }">{{ pctOfTotal(row.costCny) }}%</template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>

      <!-- 按计费模型 -->
      <el-col :xs="24" :md="12">
        <el-card class="block" shadow="never">
          <template #header><span class="block__title">按计费模型</span></template>
          <el-table :data="summary?.byBilledModel || []" size="small" empty-text="暂无数据">
            <el-table-column label="计费模型" prop="billedModel" />
            <el-table-column label="调用次数" align="right">
              <template #default="{ row }">{{ num(row.calls) }}</template>
            </el-table-column>
            <el-table-column label="Tokens" align="right">
              <template #default="{ row }">{{ num(row.tokens) }}</template>
            </el-table-column>
            <el-table-column label="费用" align="right">
              <template #default="{ row }">{{ money4(row.costCny) }}</template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-col>
    </el-row>

    <!-- 每日趋势 -->
    <el-card class="block" shadow="never">
      <template #header><span class="block__title">每日费用趋势</span></template>
      <div v-if="(summary?.daily?.length || 0) === 0" class="block__empty">暂无数据</div>
      <div v-else class="trend">
        <div v-for="d in summary?.daily || []" :key="d.date" class="trend__row">
          <span class="trend__date">{{ d.date }}</span>
          <div class="trend__bar-wrap">
            <div class="trend__bar" :style="{ width: ((Number(d.costCny) / maxDailyCost) * 100).toFixed(1) + '%' }" />
          </div>
          <span class="trend__cost">{{ money4(d.costCny) }}</span>
          <span class="trend__calls">{{ num(d.calls) }} 次</span>
        </div>
      </div>
    </el-card>

    <!-- 费用最高用户 -->
    <el-card class="block" shadow="never">
      <template #header><span class="block__title">费用最高用户（Top 20）</span></template>
      <el-table :data="summary?.topUsers || []" size="small" empty-text="暂无数据">
        <el-table-column label="用户">
          <template #default="{ row }">{{ userLabel(row) }}</template>
        </el-table-column>
        <el-table-column label="userId" prop="userId" width="100" />
        <el-table-column label="调用次数" align="right">
          <template #default="{ row }">{{ num(row.calls) }}</template>
        </el-table-column>
        <el-table-column label="费用" align="right">
          <template #default="{ row }">{{ money4(row.costCny) }}</template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 明细 -->
    <el-card class="block" shadow="never">
      <template #header>
        <div class="block__header">
          <span class="block__title">调用明细（最近 200 条）</span>
          <el-select v-model="logFeature" placeholder="全部功能" clearable style="width: 160px" @change="load">
            <el-option label="食物识别" value="food" />
            <el-option label="皮肤检测" value="skin" />
            <el-option label="中医体检" value="tcm" />
          </el-select>
        </div>
      </template>
      <el-table :data="logs" size="small" empty-text="暂无数据" max-height="520">
        <el-table-column label="时间" width="160">
          <template #default="{ row }">{{ (row.createdAt || '').replace('T', ' ').slice(0, 19) }}</template>
        </el-table-column>
        <el-table-column label="功能" width="90">
          <template #default="{ row }">{{ featureLabel(row.feature) }}</template>
        </el-table-column>
        <el-table-column label="场景" prop="scene" min-width="150" show-overflow-tooltip />
        <el-table-column label="计费模型" prop="billedModel" width="150" />
        <el-table-column label="输入(命中/未命中)" align="right" width="150">
          <template #default="{ row }">{{ num(row.cacheHitTokens) }} / {{ num(row.cacheMissTokens) }}</template>
        </el-table-column>
        <el-table-column label="输出" align="right" width="90">
          <template #default="{ row }">{{ num(row.completionTokens) }}</template>
        </el-table-column>
        <el-table-column label="合计" align="right" width="90">
          <template #default="{ row }">{{ num(row.totalTokens) }}</template>
        </el-table-column>
        <el-table-column label="费用" align="right" width="110">
          <template #default="{ row }">{{ money4(row.costCny) }}</template>
        </el-table-column>
        <el-table-column label="userId" prop="userId" width="90" />
      </el-table>
    </el-card>
  </div>
</template>

<style scoped>
.usage {
  max-width: 1200px;
}
.usage__head {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
  margin-bottom: 18px;
}
.usage__h1 {
  margin: 0 0 6px;
  font-size: 22px;
  font-weight: 700;
  color: #0f2d28;
}
.usage__sub {
  margin: 0;
  font-size: 13px;
  color: #64748b;
}
.usage__filters {
  display: flex;
  gap: 10px;
  align-items: center;
}
.usage__cards {
  margin-bottom: 8px;
}
.card {
  border-radius: 14px !important;
  border: 1px solid #e5ebe8 !important;
  margin-bottom: 16px;
}
.card__label {
  font-size: 13px;
  color: #64748b;
  margin-bottom: 8px;
}
.card__value {
  font-size: 30px;
  font-weight: 800;
  color: #0f2d28;
  line-height: 1.1;
  letter-spacing: -0.02em;
}
.card--cost .card__value {
  color: #c0392b;
}
.card__value--vendor {
  color: #b45309;
}
.card__value--ds {
  color: #12a382;
}
.cost-strong {
  color: #c0392b;
  font-variant-numeric: tabular-nums;
}
.block__hint-inline {
  margin-left: 10px;
  font-size: 12px;
  color: #94a3b8;
}
.price__provider {
  font-size: 11px;
  color: #b0bcc4;
  margin-top: 2px;
}
.card__hint {
  margin-top: 8px;
  font-size: 12px;
  color: #94a3b8;
}
.block {
  border-radius: 14px !important;
  border: 1px solid #e5ebe8 !important;
  margin-bottom: 16px;
}
.block__title {
  font-size: 15px;
  font-weight: 600;
  color: #0f2d28;
}
.block__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.block__empty {
  color: #94a3b8;
  font-size: 13px;
  padding: 12px 0;
}
.trend__row {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 4px 0;
}
.trend__date {
  width: 92px;
  flex-shrink: 0;
  font-size: 12px;
  color: #64748b;
  font-variant-numeric: tabular-nums;
}
.trend__bar-wrap {
  flex: 1;
  height: 14px;
  background: #f1f5f4;
  border-radius: 7px;
  overflow: hidden;
}
.trend__bar {
  height: 100%;
  min-width: 2px;
  background: linear-gradient(90deg, #12a382 0%, #7ee8c8 100%);
  border-radius: 7px;
}
.trend__cost {
  width: 92px;
  flex-shrink: 0;
  text-align: right;
  font-size: 13px;
  font-weight: 600;
  color: #0f2d28;
  font-variant-numeric: tabular-nums;
}
.trend__calls {
  width: 70px;
  flex-shrink: 0;
  text-align: right;
  font-size: 12px;
  color: #94a3b8;
  font-variant-numeric: tabular-nums;
}
</style>
