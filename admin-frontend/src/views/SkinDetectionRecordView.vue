<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage } from 'element-plus'
import { downloadSkinDetectionRecordPdf, fetchSkinDetectionRecordDetail, fetchSkinDetectionRecords } from '../api/admin'
import type { SkinDetectionRecord, SkinDetectionRecordDetail } from '../types/admin'

const loading = ref(false)
const detailLoading = ref(false)
const rows = ref<SkinDetectionRecord[]>([])
const detailVisible = ref(false)
const detail = ref<SkinDetectionRecordDetail | null>(null)
const pdfDownloading = ref(false)

const filters = reactive({
  phone: '',
  status: '',
  dateRange: [] as string[],
  minScore: undefined as number | undefined,
  maxScore: undefined as number | undefined,
})

const imageUrl = computed(() => normalizeResourceUrl(detail.value?.imageUrl || ''))

function normalizeResourceUrl(raw: string) {
  if (!raw) return ''
  if (/^https?:\/\//i.test(raw)) return raw
  const base = (import.meta.env.VITE_API_BASE_URL || '/api/v1').replace(/\/api\/v1\/?$/, '')
  const path = raw.startsWith('/') ? raw : `/${raw}`
  return `${base}${path}`
}

function itemDescription(row: { aiConclusion?: string | null; resultText?: string | null; aiReason?: string | null; aiCareAdvice?: string | null; aiError?: string | null }) {
  const lines: string[] = []
  if (row.aiConclusion?.trim()) lines.push(`诊断结论：${row.aiConclusion.trim()}`)
  if (row.aiReason?.trim()) lines.push(`产生原因：${row.aiReason.trim()}`)
  if (row.aiCareAdvice?.trim()) lines.push(`护理建议：${row.aiCareAdvice.trim()}`)
  if (lines.length) return lines.join('\n')
  return row.resultText || row.aiError || '--'
}

async function loadRows() {
  loading.value = true
  try {
    rows.value = await fetchSkinDetectionRecords({
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

async function openDetail(row: SkinDetectionRecord) {
  detailVisible.value = true
  detailLoading.value = true
  detail.value = null
  try {
    detail.value = await fetchSkinDetectionRecordDetail(row.id)
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
  if (!detail.value) return '皮肤诊断报告.pdf'
  const date = (detail.value.createdAt || '').slice(0, 10).replace(/-/g, '') || new Date().toISOString().slice(0, 10).replace(/-/g, '')
  const rawName = detail.value.userName?.trim() || `用户${detail.value.recordId}`
  const name = rawName.replace(/[\\/:*?"<>|\s]+/g, '') || `用户${detail.value.recordId}`
  return `${date}-${name}-皮肤诊断报告.pdf`
}

async function downloadPdf() {
  if (!detail.value?.recordId) return
  pdfDownloading.value = true
  try {
    const blob = await downloadSkinDetectionRecordPdf(detail.value.recordId)
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
  <div class="skin-record-page">
    <el-card class="page-intro" shadow="never">
      <div class="page-intro__title">皮肤检测记录</div>
      <div class="page-intro__desc">查询小程序提交的皮肤检测记录，支持手机号、时间、状态和综合分筛选，可查看单次检测详情。</div>
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
        <el-table-column prop="overallScore" label="综合分" width="100" />
        <el-table-column prop="deepseekStatus" label="AI状态" width="110" />
        <el-table-column prop="createdAt" label="检测时间" min-width="180" />
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }"><el-button link type="primary" @click="openDetail(row)">查看详情</el-button></template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="detailVisible" title="皮肤检测详情" width="920px">
      <div v-loading="detailLoading">
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

          <el-descriptions :column="3" border class="detail-desc">
            <el-descriptions-item label="用户ID">{{ detail.userId }}</el-descriptions-item>
            <el-descriptions-item label="手机号">{{ detail.phone || '--' }}</el-descriptions-item>
            <el-descriptions-item label="姓名">{{ detail.userName || '--' }}</el-descriptions-item>
            <el-descriptions-item label="性别">{{ genderLabel(detail.gender) }}</el-descriptions-item>
            <el-descriptions-item label="年龄">{{ detail.age || '--' }}</el-descriptions-item>
            <el-descriptions-item label="居住地">{{ detail.residence || '--' }}</el-descriptions-item>
            <el-descriptions-item label="检测项">{{ detail.detectTypes || '--' }}</el-descriptions-item>
            <el-descriptions-item label="综合分">{{ detail.overallScore ?? '--' }}</el-descriptions-item>
            <el-descriptions-item label="DeepSeek状态">{{ detail.deepseekStatus || '--' }}</el-descriptions-item>
          </el-descriptions>

          <el-alert v-if="detail.failReason" :title="detail.failReason" type="error" show-icon :closable="false" class="detail-alert" />
          <el-alert v-if="detail.deepseekError" :title="detail.deepseekError" type="warning" show-icon :closable="false" class="detail-alert" />

          <div class="detail-grid">
            <div v-if="imageUrl" class="image-panel">
              <div class="panel-title">检测图片</div>
              <el-image :src="imageUrl" fit="cover" class="detect-image" :preview-src-list="[imageUrl]">
                <template #error>
                  <div class="image-error">图片加载失败</div>
                </template>
              </el-image>
            </div>
            <div class="summary-panel">
              <div class="panel-title">综合分析</div>
              <div class="ai-summary">{{ detail.aiSummary || '暂无综合分析' }}</div>
            </div>
          </div>

          <div class="panel-title item-title">6 项检测明细</div>
          <el-table :data="detail.items" border>
            <el-table-column prop="itemName" label="检测项" width="120" />
            <el-table-column prop="score" label="分数" width="90" />
            <el-table-column prop="level" label="等级" width="130" />
            <el-table-column label="说明" min-width="420">
              <template #default="{ row }"><div class="item-description">{{ itemDescription(row) }}</div></template>
            </el-table-column>
            <el-table-column prop="metricsJson" label="扩展指标" min-width="220" show-overflow-tooltip />
          </el-table>
        </template>
      </div>
    </el-dialog>
  </div>
</template>

<style scoped>
.skin-record-page { display: grid; gap: 16px; }
.page-intro { border: 1px solid #e5ebe8; background: #fafdfb; }
.page-intro__title { font-size: 16px; font-weight: 700; color: #0f2d28; }
.page-intro__desc { margin-top: 6px; font-size: 13px; color: #64748b; line-height: 1.7; }
.filter-bar { display: flex; flex-wrap: wrap; align-items: center; gap: 8px; }
.detail-head { display: flex; align-items: center; justify-content: space-between; gap: 16px; }
.detail-title { font-size: 18px; font-weight: 700; color: #0f2d28; }
.detail-sub { margin-top: 6px; font-size: 13px; color: #64748b; }
.detail-actions { display: flex; align-items: center; gap: 10px; }
.detail-desc, .detail-alert { margin-top: 16px; }
.detail-grid { margin-top: 16px; display: grid; grid-template-columns: 220px 1fr; gap: 16px; align-items: stretch; }
.image-panel, .summary-panel { border: 1px solid #e5ebe8; border-radius: 10px; padding: 12px; background: #fafdfb; }
.panel-title { font-size: 14px; font-weight: 700; color: #0f2d28; margin-bottom: 10px; }
.detect-image { width: 100%; height: 220px; border-radius: 8px; background: #f1f5f9; }
.image-error { width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; color: #94a3b8; font-size: 13px; background: #f8fafc; }
.ai-summary { white-space: pre-wrap; line-height: 1.8; color: #334155; font-size: 14px; }
.item-description { white-space: pre-line; line-height: 1.7; color: #334155; font-size: 13px; }
.item-title { margin-top: 18px; }
</style>
