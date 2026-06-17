<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { downloadTcmDetectionRecordPdf, fetchTcmDetectionRecordDetail, fetchTcmDetectionRecords } from '../api/admin'
import type {
  TcmDetectionRecord,
  TcmDetectionRecordDetail,
  TcmDetectionRecordItem,
  TcmDetectionReport,
  TcmInspectionMetrics,
} from '../types/admin'

const loading = ref(false)
const detailLoading = ref(false)
const rows = ref<TcmDetectionRecord[]>([])
const detailVisible = ref(false)
const detail = ref<TcmDetectionRecordDetail | null>(null)
const pdfDownloading = ref(false)

const filters = reactive({
  phone: '',
  status: '',
  dateRange: [] as string[],
  minScore: undefined as number | undefined,
  maxScore: undefined as number | undefined,
})

function normalizeResourceUrl(raw: string) {
  if (!raw) return ''
  if (/^https?:\/\//i.test(raw)) return raw
  const base = (import.meta.env.VITE_API_BASE_URL || '/api/v1').replace(/\/api\/v1\/?$/, '')
  const path = raw.startsWith('/') ? raw : `/${raw}`
  return `${base}${path}`
}

const tongueImageUrl = computed(() => normalizeResourceUrl(detail.value?.tongueImageUrl || ''))
const faceImageUrl = computed(() => normalizeResourceUrl(detail.value?.faceImageUrl || ''))

/** reportJson 是 JSON 字符串，安全解析为结构化对象 */
const report = computed<TcmDetectionReport | null>(() => {
  const raw = detail.value?.reportJson
  if (!raw) return null
  try {
    const parsed = JSON.parse(raw)
    return parsed && typeof parsed === 'object' ? (parsed as TcmDetectionReport) : null
  } catch {
    return null
  }
})

const annotatedTongueUrl = computed(() => normalizeResourceUrl(report.value?.annotatedTongueUrl || ''))

/** 记录按性别过滤异性专属内容（脉景返回不分性别） */
const FEMALE_KW = [
  '女性', '月经', '痛经', '经量', '经色', '经期', '经血', '行经', '闭经', '崩漏', '带下', '白带', '经带',
  '妊娠', '怀孕', '孕', '胎', '产后', '外阴', '阴道', '子宫', '宫颈', '卵巢', '乳腺', '乳房', '妇科',
]
const MALE_KW = ['男性', '阴囊', '睾丸', '前列腺', '遗精', '阳痿', '早泄', '龟头', '包皮', '精液', '精子', '勃起']
function filterByGender(text: string | undefined, delimiter: string): string {
  if (!text) return ''
  const g = detail.value?.gender
  const kw = g === 1 ? FEMALE_KW : g === 2 ? MALE_KW : null
  if (!kw) return text
  return text
    .split(delimiter)
    .filter((p) => !kw.some((k) => p.includes(k)))
    .join(delimiter)
}
const displayTypicalSymptom = computed(() => filterByGender(report.value?.typicalSymptom, '；'))
const displayRiskWarning = computed(() => filterByGender(report.value?.riskWarning, '\n'))

/** 调理建议：food/sleep/sport/treatment/music 均为 {title,advice}[] 数组 */
const adviceGroups = computed(() => {
  const a = report.value?.advices
  if (!a) return []
  const order = [
    { label: '饮食建议', key: 'food' as const },
    { label: '起居建议', key: 'sleep' as const },
    { label: '运动建议', key: 'sport' as const },
    { label: '调理建议', key: 'treatment' as const },
    { label: '音乐建议', key: 'music' as const },
  ]
  return order
    .map((o) => ({ label: o.label, items: (a[o.key] ?? []).filter((it) => it?.title || it?.advice) }))
    .filter((g) => g.items.length)
})

const goods = computed(() => (report.value?.goods || []).filter((g) => g?.name || g?.img1))

/** 望诊特征按 scaleType 分组（面部 / 舌部 / 其他） */
const faceItems = computed(() => (detail.value?.items || []).filter((i) => i.scaleType === '面部'))
const tongueItems = computed(() => (detail.value?.items || []).filter((i) => i.scaleType === '舌部'))
const otherItems = computed(() =>
  (detail.value?.items || []).filter((i) => i.scaleType !== '面部' && i.scaleType !== '舌部'),
)

function parseMetrics(raw: string | null): TcmInspectionMetrics | null {
  if (!raw) return null
  try {
    const parsed = JSON.parse(raw)
    return parsed && typeof parsed === 'object' ? (parsed as TcmInspectionMetrics) : null
  } catch {
    return null
  }
}

/** 异常项标红 */
function isAbnormal(item: TcmDetectionRecordItem) {
  return (item.level || '').trim() === '异常'
}

function itemReason(item: TcmDetectionRecordItem) {
  if (item.resultText?.trim()) return item.resultText.trim()
  const metrics = parseMetrics(item.metricsJson)
  return metrics?.situation?.trim() || '--'
}

async function loadRows() {
  loading.value = true
  try {
    rows.value = await fetchTcmDetectionRecords({
      phone: filters.phone.trim() || undefined,
      status: filters.status || undefined,
      startDate: filters.dateRange?.[0],
      endDate: filters.dateRange?.[1],
      minScore: filters.minScore,
      maxScore: filters.maxScore,
    })
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载失败')
  } finally {
    loading.value = false
  }
}

async function openDetail(row: TcmDetectionRecord) {
  detailVisible.value = true
  detailLoading.value = true
  detail.value = null
  try {
    detail.value = await fetchTcmDetectionRecordDetail(row.id)
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : '加载详情失败')
  } finally {
    detailLoading.value = false
  }
}

function resetFilters() {
  filters.phone = ''
  filters.status = ''
  filters.dateRange = []
  filters.minScore = undefined
  filters.maxScore = undefined
  loadRows()
}

function statusLabel(status: string) {
  if (status === 'success') return '成功'
  if (status === 'failed') return '失败'
  if (status === 'pending') return '处理中'
  return status
}

function statusType(status: string) {
  if (status === 'success') return 'success'
  if (status === 'failed') return 'danger'
  return 'warning'
}

function genderLabel(gender: number | null) {
  if (gender === 1) return '男'
  if (gender === 2) return '女'
  return '--'
}

function pdfFilename() {
  if (!detail.value) return '中医体质报告.pdf'
  const date = (detail.value.createdAt || '').slice(0, 10).replace(/-/g, '') || new Date().toISOString().slice(0, 10).replace(/-/g, '')
  const rawName = detail.value.userName?.trim() || `用户${detail.value.recordId}`
  const name = rawName.replace(/[\\/:*?"<>|\s]+/g, '') || `用户${detail.value.recordId}`
  return `${date}-${name}-中医体质报告.pdf`
}

async function downloadPdf() {
  if (!detail.value?.recordId) return
  pdfDownloading.value = true
  try {
    const blob = await downloadTcmDetectionRecordPdf(detail.value.recordId)
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = pdfFilename()
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    window.URL.revokeObjectURL(url)
    ElMessage.success('PDF 已开始下载')
  } catch (e) {
    ElMessage.error(e instanceof Error ? e.message : 'PDF 下载失败')
  } finally {
    pdfDownloading.value = false
  }
}

onMounted(loadRows)
</script>

<template>
  <div class="tcm-record-page">
    <el-card class="page-intro" shadow="never">
      <div class="page-intro__title">中医体检记录</div>
      <div class="page-intro__desc">查询小程序提交的中医体检记录，支持手机号、时间、状态和综合分筛选，可查看单次检测详情。</div>
    </el-card>

    <el-card>
      <template #header>
        <div class="filter-bar">
          <el-input v-model="filters.phone" placeholder="手机号" clearable style="width: 180px" />
          <el-select v-model="filters.status" placeholder="状态" clearable style="width: 130px">
            <el-option label="成功" value="success" />
            <el-option label="失败" value="failed" />
            <el-option label="处理中" value="pending" />
          </el-select>
          <el-date-picker v-model="filters.dateRange" type="daterange" value-format="YYYY-MM-DD" start-placeholder="开始日期" end-placeholder="结束日期" style="width: 260px" />
          <el-input-number v-model="filters.minScore" :min="0" :max="100" placeholder="最低分" style="width: 120px" />
          <el-input-number v-model="filters.maxScore" :min="0" :max="100" placeholder="最高分" style="width: 120px" />
          <el-button type="primary" @click="loadRows">查询</el-button>
          <el-button @click="resetFilters">重置</el-button>
        </div>
      </template>

      <el-table :data="rows" v-loading="loading" border>
        <el-table-column prop="id" label="ID" width="90" />
        <el-table-column prop="phone" label="手机号" min-width="140" />
        <el-table-column prop="userName" label="姓名" min-width="120" />
        <el-table-column label="状态" width="100">
          <template #default="{ row }"><el-tag :type="statusType(row.status)">{{ statusLabel(row.status) }}</el-tag></template>
        </el-table-column>
        <el-table-column prop="constitutionPrimary" label="主体质" min-width="160" show-overflow-tooltip />
        <el-table-column prop="overallScore" label="综合分" width="100" />
        <el-table-column prop="deepseekStatus" label="AI状态" width="110" />
        <el-table-column prop="createdAt" label="检测时间" min-width="180" />
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }"><el-button link type="primary" @click="openDetail(row)">查看详情</el-button></template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="detailVisible" title="中医体检详情" width="960px" top="6vh">
      <div v-loading="detailLoading" class="detail-body">
        <template v-if="detail">
          <div class="detail-head">
            <div>
              <div class="detail-title">记录 #{{ detail.recordId }}</div>
              <div class="detail-sub">检测时间：{{ detail.createdAt }}</div>
            </div>
            <div class="detail-actions">
              <el-tag :type="statusType(detail.status)">{{ statusLabel(detail.status) }}</el-tag>
              <el-button type="primary" plain :loading="pdfDownloading" @click="downloadPdf">导出 PDF</el-button>
            </div>
          </div>

          <!-- 基本信息 -->
          <el-descriptions :column="3" border class="detail-desc">
            <el-descriptions-item label="用户ID">{{ detail.userId }}</el-descriptions-item>
            <el-descriptions-item label="手机号">{{ detail.phone || '--' }}</el-descriptions-item>
            <el-descriptions-item label="姓名">{{ detail.userName || '--' }}</el-descriptions-item>
            <el-descriptions-item label="性别">{{ genderLabel(detail.gender) }}</el-descriptions-item>
            <el-descriptions-item label="年龄">{{ detail.age || '--' }}</el-descriptions-item>
            <el-descriptions-item label="居住地">{{ detail.residence || '--' }}</el-descriptions-item>
            <el-descriptions-item label="综合分">{{ detail.overallScore ?? '--' }}</el-descriptions-item>
            <el-descriptions-item label="主体质" :span="2">{{ detail.constitutionPrimary || '--' }}</el-descriptions-item>
            <el-descriptions-item label="DeepSeek状态">{{ detail.deepseekStatus || '--' }}</el-descriptions-item>
          </el-descriptions>

          <el-alert v-if="detail.failReason" :title="detail.failReason" type="error" show-icon :closable="false" class="detail-alert" />
          <el-alert v-if="detail.deepseekError" :title="detail.deepseekError" type="warning" show-icon :closable="false" class="detail-alert" />

          <!-- 图片 + 综合分析 -->
          <div class="detail-grid">
            <div class="image-panel">
              <div class="panel-title">舌象图</div>
              <el-image v-if="tongueImageUrl" :src="tongueImageUrl" fit="cover" class="detect-image" :preview-src-list="[tongueImageUrl]">
                <template #error>
                  <div class="image-error">图片加载失败</div>
                </template>
              </el-image>
              <div v-else class="image-error">暂无舌象图</div>
            </div>
            <div class="image-panel">
              <div class="panel-title">面象图</div>
              <el-image v-if="faceImageUrl" :src="faceImageUrl" fit="cover" class="detect-image" :preview-src-list="[faceImageUrl]">
                <template #error>
                  <div class="image-error">图片加载失败</div>
                </template>
              </el-image>
              <div v-else class="image-error">暂无面象图</div>
            </div>
            <div class="summary-panel">
              <div class="panel-title">AI 综合分析</div>
              <div class="ai-summary">{{ detail.aiSummary || '暂无综合分析' }}</div>
            </div>
          </div>

          <!-- 体质报告（reportJson 解析） -->
          <template v-if="report">
            <div class="section-title">体质报告</div>
            <div class="report-block">
              <div v-if="report.physiqueName" class="report-row">
                <span class="report-label">体质名称</span>
                <span class="report-value">{{ report.physiqueName }}</span>
              </div>
              <div v-if="report.physiqueAnalysis" class="report-row">
                <span class="report-label">体质分析</span>
                <span class="report-value report-text">{{ report.physiqueAnalysis }}</span>
              </div>
              <div v-if="displayTypicalSymptom" class="report-row">
                <span class="report-label">典型症状</span>
                <span class="report-value report-text">{{ displayTypicalSymptom }}</span>
              </div>
              <div v-if="displayRiskWarning" class="report-row">
                <span class="report-label">风险提示</span>
                <span class="report-value report-text report-warning">{{ displayRiskWarning }}</span>
              </div>
              <div v-if="report.syndromeName" class="report-row">
                <span class="report-label">证型</span>
                <span class="report-value">{{ report.syndromeName }}</span>
              </div>
              <div v-if="report.syndromeIntroduction" class="report-row">
                <span class="report-label">证型介绍</span>
                <span class="report-value report-text">{{ report.syndromeIntroduction }}</span>
              </div>
            </div>

            <!-- 调理建议 -->
            <template v-if="adviceGroups.length">
              <div class="section-title">调理建议</div>
              <div class="advice-block">
                <div v-for="grp in adviceGroups" :key="grp.label" class="advice-group">
                  <div class="advice-group-title">{{ grp.label }}</div>
                  <div v-for="(adv, idx) in grp.items" :key="idx" class="advice-food">
                    <span v-if="adv.title" class="advice-food-title">{{ adv.title }}</span>
                    <span v-if="adv.advice" class="advice-food-text">{{ adv.advice }}</span>
                  </div>
                </div>
              </div>
            </template>

            <!-- 推荐商品 -->
            <template v-if="goods.length">
              <div class="section-title">推荐商品</div>
              <div class="goods-block">
                <div v-for="(item, idx) in goods" :key="idx" class="goods-card">
                  <el-image v-if="item.img1" :src="normalizeResourceUrl(item.img1)" fit="cover" class="goods-image" :preview-src-list="[normalizeResourceUrl(item.img1)]">
                    <template #error>
                      <div class="goods-image-error">图</div>
                    </template>
                  </el-image>
                  <div v-else class="goods-image-error">图</div>
                  <div class="goods-name">{{ item.name || '--' }}</div>
                </div>
              </div>
            </template>

            <!-- 标注舌象图（如有） -->
            <template v-if="annotatedTongueUrl">
              <div class="section-title">标注舌象</div>
              <el-image :src="annotatedTongueUrl" fit="contain" class="annotated-image" :preview-src-list="[annotatedTongueUrl]">
                <template #error>
                  <div class="image-error">图片加载失败</div>
                </template>
              </el-image>
            </template>
          </template>
          <el-empty v-else-if="!detail.reportJson" description="暂无体质报告" :image-size="64" />

          <!-- 望诊特征 -->
          <template v-if="detail.items && detail.items.length">
            <div class="section-title">面部望诊特征</div>
            <el-table v-if="faceItems.length" :data="faceItems" border size="small">
              <el-table-column prop="itemName" label="特征" min-width="160" />
              <el-table-column label="结果" width="100">
                <template #default="{ row }">
                  <el-tag :type="isAbnormal(row) ? 'danger' : 'success'" size="small">{{ row.level || '--' }}</el-tag>
                </template>
              </el-table-column>
              <el-table-column label="解读" min-width="420">
                <template #default="{ row }"><div class="item-reason" :class="{ 'item-reason--abnormal': isAbnormal(row) }">{{ itemReason(row) }}</div></template>
              </el-table-column>
            </el-table>
            <el-empty v-else description="暂无面部特征" :image-size="48" />

            <div class="section-title">舌部望诊特征</div>
            <el-table v-if="tongueItems.length" :data="tongueItems" border size="small">
              <el-table-column prop="itemName" label="特征" min-width="160" />
              <el-table-column label="结果" width="100">
                <template #default="{ row }">
                  <el-tag :type="isAbnormal(row) ? 'danger' : 'success'" size="small">{{ row.level || '--' }}</el-tag>
                </template>
              </el-table-column>
              <el-table-column label="解读" min-width="420">
                <template #default="{ row }"><div class="item-reason" :class="{ 'item-reason--abnormal': isAbnormal(row) }">{{ itemReason(row) }}</div></template>
              </el-table-column>
            </el-table>
            <el-empty v-else description="暂无舌部特征" :image-size="48" />

            <template v-if="otherItems.length">
              <div class="section-title">其他特征</div>
              <el-table :data="otherItems" border size="small">
                <el-table-column prop="itemName" label="特征" min-width="160" />
                <el-table-column prop="scaleType" label="部位" width="100" />
                <el-table-column label="结果" width="100">
                  <template #default="{ row }">
                    <el-tag :type="isAbnormal(row) ? 'danger' : 'success'" size="small">{{ row.level || '--' }}</el-tag>
                  </template>
                </el-table-column>
                <el-table-column label="解读" min-width="360">
                  <template #default="{ row }"><div class="item-reason" :class="{ 'item-reason--abnormal': isAbnormal(row) }">{{ itemReason(row) }}</div></template>
                </el-table-column>
              </el-table>
            </template>
          </template>
        </template>
      </div>
    </el-dialog>
  </div>
</template>

<style scoped>
.tcm-record-page { display: grid; gap: 16px; }
.page-intro { border: 1px solid #e5ebe8; background: #fafdfb; }
.page-intro__title { font-size: 16px; font-weight: 700; color: #0f2d28; }
.page-intro__desc { margin-top: 6px; font-size: 13px; color: #64748b; line-height: 1.7; }
.filter-bar { display: flex; flex-wrap: wrap; align-items: center; gap: 8px; }
.detail-body { max-height: 76vh; overflow-y: auto; padding-right: 4px; }
.detail-head { display: flex; align-items: center; justify-content: space-between; gap: 16px; }
.detail-title { font-size: 18px; font-weight: 700; color: #0f2d28; }
.detail-sub { margin-top: 6px; font-size: 13px; color: #64748b; }
.detail-actions { display: flex; align-items: center; gap: 10px; }
.detail-desc, .detail-alert { margin-top: 16px; }
.detail-grid { margin-top: 16px; display: grid; grid-template-columns: 220px 220px 1fr; gap: 16px; align-items: stretch; }
.image-panel, .summary-panel { border: 1px solid #e5ebe8; border-radius: 10px; padding: 12px; background: #fafdfb; }
.panel-title { font-size: 14px; font-weight: 700; color: #0f2d28; margin-bottom: 10px; }
.detect-image { width: 100%; height: 220px; border-radius: 8px; background: #f1f5f9; }
.image-error { width: 100%; height: 220px; display: flex; align-items: center; justify-content: center; color: #94a3b8; font-size: 13px; background: #f8fafc; border-radius: 8px; }
.ai-summary { white-space: pre-wrap; line-height: 1.8; color: #334155; font-size: 14px; }
.section-title { margin-top: 22px; margin-bottom: 12px; font-size: 15px; font-weight: 700; color: #0f2d28; padding-left: 10px; border-left: 3px solid #2f9e7e; }
.report-block { border: 1px solid #e5ebe8; border-radius: 10px; background: #fafdfb; padding: 4px 14px; }
.report-row { display: flex; gap: 12px; padding: 10px 0; border-bottom: 1px dashed #e5ebe8; }
.report-row:last-child { border-bottom: none; }
.report-label { flex: 0 0 78px; font-size: 13px; font-weight: 600; color: #0f2d28; }
.report-value { flex: 1; font-size: 13px; color: #334155; line-height: 1.7; }
.report-text { white-space: pre-wrap; }
.report-warning { color: #c0392b; }
.advice-block { display: grid; gap: 14px; }
.advice-group { border: 1px solid #e5ebe8; border-radius: 10px; background: #fafdfb; padding: 12px 14px; }
.advice-group-title { font-size: 13px; font-weight: 700; color: #2f9e7e; margin-bottom: 8px; }
.advice-food { padding: 6px 0; border-bottom: 1px dashed #e5ebe8; }
.advice-food:last-child { border-bottom: none; }
.advice-food-title { font-size: 13px; font-weight: 600; color: #0f2d28; margin-right: 8px; }
.advice-food-text { font-size: 13px; color: #334155; line-height: 1.7; }
.advice-text { font-size: 13px; color: #334155; line-height: 1.8; white-space: pre-wrap; }
.goods-block { display: flex; flex-wrap: wrap; gap: 14px; }
.goods-card { width: 132px; border: 1px solid #e5ebe8; border-radius: 10px; background: #fafdfb; padding: 10px; }
.goods-image { width: 100%; height: 112px; border-radius: 8px; background: #f1f5f9; }
.goods-image-error { width: 100%; height: 112px; display: flex; align-items: center; justify-content: center; color: #94a3b8; font-size: 13px; background: #f8fafc; border-radius: 8px; }
.goods-name { margin-top: 8px; font-size: 13px; color: #334155; line-height: 1.5; text-align: center; }
.annotated-image { max-width: 320px; border-radius: 8px; background: #f1f5f9; }
.item-reason { white-space: pre-line; line-height: 1.7; color: #334155; font-size: 13px; }
.item-reason--abnormal { color: #c0392b; }
</style>
