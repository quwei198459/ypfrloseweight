<template>
  <view class="tcm-page">
    <view v-if="loading" class="empty-card">报告加载中...</view>

    <view v-else-if="isFailed" class="empty-card fail-card">
      <text class="fail-title">体质辨识未完成</text>
      <text class="fail-desc">{{ report?.failReason || '本次辨识失败，请重新拍摄后再试。' }}</text>
      <button class="primary-btn" @click="restart">重新检测</button>
    </view>

    <template v-else-if="report">
      <!-- 上传图像 -->
      <view class="card image-card">
        <view class="image-row">
          <view class="image-col">
            <image v-if="tongueImage" class="upload-image" :src="tongueImage" mode="aspectFill" />
            <view v-else class="upload-image upload-image--empty">暂无舌象</view>
            <text class="image-caption">舌象</text>
          </view>
          <view class="image-col">
            <image v-if="faceImage" class="upload-image" :src="faceImage" mode="aspectFill" />
            <view v-else class="upload-image upload-image--empty">暂无面象</view>
            <text class="image-caption">面象</text>
          </view>
        </view>
      </view>

      <!-- 综合分 + 主体质 -->
      <view class="score-card">
        <text class="eyebrow">中医体检报告</text>
        <view class="score-row">
          <text class="score">{{ report.overallScore ?? '--' }}</text>
          <text class="score-unit">分</text>
        </view>
        <text class="score-label">综合体质分</text>
        <view class="constitution-wrap">
          <text class="constitution-label">主体质</text>
          <text class="constitution">{{ report.constitutionPrimary || '--' }}</text>
        </view>
      </view>

      <!-- AI 总结（兜底 physiqueAnalysis） -->
      <view class="card summary-card">
        <text class="section-title">体质总结</text>
        <text class="paragraph">{{ summaryText }}</text>
      </view>

      <!-- 体质分析 / 典型症状 / 风险提示 / 证型 -->
      <view v-if="parsed.physiqueAnalysis" class="card">
        <text class="section-title">体质分析</text>
        <text class="paragraph">{{ parsed.physiqueAnalysis }}</text>
      </view>

      <view v-if="typicalSymptomLines.length" class="card">
        <text class="section-title">典型症状</text>
        <view class="symptom-list">
          <view v-for="(line, i) in typicalSymptomLines" :key="i" class="symptom-line">
            <text class="symptom-dot">·</text>
            <text class="symptom-text">{{ line }}</text>
          </view>
        </view>
      </view>

      <view v-if="riskWarningText" class="card risk-card">
        <text class="section-title">风险提示</text>
        <text class="paragraph">{{ riskWarningText }}</text>
      </view>

      <view v-if="parsed.syndromeName || parsed.syndromeIntroduction" class="card">
        <text class="section-title">证型</text>
        <text v-if="parsed.syndromeName" class="syndrome-name">{{ parsed.syndromeName }}</text>
        <text v-if="parsed.syndromeIntroduction" class="paragraph">{{ parsed.syndromeIntroduction }}</text>
      </view>

      <!-- 望诊特征：面部 / 舌部 -->
      <view v-for="grp in itemGroups" :key="grp.key" class="card">
        <text class="section-title">{{ grp.label }}特征</text>
        <view
          class="feature-item"
          v-for="item in grp.items"
          :key="item.itemCode"
          @click="openDetail(item.itemCode)"
        >
          <view class="feature-head">
            <text class="feature-name">{{ item.itemName }}</text>
            <view class="feature-right">
              <text class="feature-tag" :class="isAbnormal(item.level) ? 'feature-tag--abnormal' : 'feature-tag--normal'">
                {{ item.level || '正常' }}
              </text>
              <text class="feature-arrow">›</text>
            </view>
          </view>
          <text v-if="item.resultText" class="feature-desc">{{ item.resultText }}</text>
        </view>
      </view>

      <!-- 调理建议 -->
      <view v-if="adviceGroups.length" class="card">
        <text class="section-title">调理建议</text>
        <view v-for="grp in adviceGroups" :key="grp.key" class="advice-group">
          <view class="advice-group-head">
            <text class="advice-group-icon">{{ grp.icon }}</text>
            <text class="advice-group-title">{{ grp.label }}</text>
          </view>
          <view v-for="(adv, i) in grp.items" :key="i" class="advice-item">
            <text v-if="adv.title" class="advice-title">{{ adv.title }}</text>
            <text class="advice-text">{{ adv.advice }}</text>
          </view>
        </view>
      </view>

      <!-- 检测资料 -->
      <view class="card info-card">
        <text class="section-title">检测资料</text>
        <text class="info-line">姓名：{{ report.userName || '--' }}</text>
        <text class="info-line">年龄：{{ report.age || '--' }}</text>
        <text class="info-line">检测时间：{{ report.createdAt || '--' }}</text>
      </view>

      <!-- 温馨提示 -->
      <view class="notice-card">
        <text class="notice-title">温馨提示</text>
        <text class="notice-text">本报告基于中医体质辨识理论，仅供日常养生调理参考，不作为医疗诊断依据。如有不适，请咨询专业中医师。</text>
      </view>

      <button class="primary-btn" @click="showService = true">定制调理方案</button>
      <button class="secondary-btn" @click="restart">重新检测</button>
    </template>

    <view v-if="showService" class="mask" @click="showService = false">
      <view class="service-panel" @click.stop>
        <text class="panel-title">联系客服定制调理方案</text>
        <text class="panel-desc">添加客服微信或拨打电话，获取更细致的体质调理建议。</text>
        <view v-if="showQr" class="qr-wrap">
          <image class="qr" :src="qrUrl" mode="aspectFit" @error="onQrError" />
        </view>
        <view v-else class="qr-placeholder">暂无客服二维码</view>
        <text class="service-line">微信：{{ service?.serviceWechat || '--' }}</text>
        <text class="service-line">电话：{{ service?.servicePhone || '--' }}</text>
        <button v-if="showQr" class="secondary-btn panel-save-btn" @click="saveQrToAlbum">保存二维码到相册</button>
        <button class="primary-btn panel-btn" @click="showService = false">我知道了</button>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { API_BASE_URL } from '@/config/api'
import {
  getTcmCustomerService,
  getTcmDetectionReport,
  type TcmCustomerServiceVo,
  type TcmDetectionItemVo,
  type TcmDetectionReportVo,
  type TcmReportJson,
} from '@/api/tcmDetection'
import { useUserStore } from '@/stores/user'

const userStore = useUserStore()
const loading = ref(true)
const report = ref<TcmDetectionReportVo | null>(null)
const service = ref<TcmCustomerServiceVo | null>(null)
const showService = ref(false)
const qrLoadFailed = ref(false)

function absoluteUrl(raw: string | null | undefined): string {
  if (!raw) return ''
  if (/^https?:\/\//i.test(raw)) return raw
  const path = raw.startsWith('/') ? raw : `/${raw}`
  return `${API_BASE_URL}${path}`
}

const isFailed = computed(() => report.value?.status === 'failed')

const tongueImage = computed(() => absoluteUrl(report.value?.tongueImageUrl))
const faceImage = computed(() => absoluteUrl(report.value?.faceImageUrl))

/** reportJson 是字符串，需 JSON.parse；解析失败降级为空对象 */
const parsed = computed<TcmReportJson>(() => {
  const raw = report.value?.reportJson
  if (!raw) return {}
  try {
    const obj = JSON.parse(raw)
    return obj && typeof obj === 'object' ? (obj as TcmReportJson) : {}
  } catch {
    return {}
  }
})

/** AI 总结，为空/失败时兜底体质分析 */
const summaryText = computed(() => {
  const ai = report.value?.aiSummary
  if (ai && ai.trim()) return ai
  return parsed.value.physiqueAnalysis || '暂无综合分析'
})

/** 报告需过滤异性专属内容（脉景返回不分性别） */
const FEMALE_KW = [
  '女性', '月经', '痛经', '经量', '经色', '经期', '经血', '行经', '闭经', '崩漏', '带下', '白带', '经带',
  '妊娠', '怀孕', '孕', '胎', '产后', '外阴', '阴道', '子宫', '宫颈', '卵巢', '乳腺', '乳房', '妇科',
]
const MALE_KW = ['男性', '阴囊', '睾丸', '前列腺', '遗精', '阳痿', '早泄', '龟头', '包皮', '精液', '精子', '勃起']
/** 与当前性别相反的专属词：男(1)→女性词，女(2)→男性词 */
function hasOppositeGenderWord(s: string): boolean {
  const g = report.value?.gender
  if (g === 1) return FEMALE_KW.some((k) => s.includes(k))
  if (g === 2) return MALE_KW.some((k) => s.includes(k))
  return false
}

/** 典型症状按 ；/; 分行；过滤异性专属症状 */
const typicalSymptomLines = computed(() => {
  const raw = parsed.value.typicalSymptom
  if (!raw) return []
  return raw
    .split(/[；;]/)
    .map((s) => s.trim())
    .filter(Boolean)
    .filter((s) => !hasOppositeGenderWord(s))
})

/** 风险提示按段过滤；去掉异性专属段落 */
const riskWarningText = computed(() => {
  const raw = parsed.value.riskWarning
  if (!raw) return ''
  return raw
    .split('\n')
    .filter((p) => !hasOppositeGenderWord(p))
    .join('\n')
})

function isAbnormal(level: string | null | undefined): boolean {
  return (level || '').trim() === '异常'
}

/** 望诊特征按 scaleType 分组：面部 / 舌部 */
const itemGroups = computed(() => {
  const items = report.value?.items || []
  const sortFn = (a: TcmDetectionItemVo, b: TcmDetectionItemVo) =>
    (a.sortOrder ?? 0) - (b.sortOrder ?? 0)
  const face = items.filter((it) => (it.scaleType || '') === '面部').sort(sortFn)
  const tongue = items.filter((it) => (it.scaleType || '') === '舌部').sort(sortFn)
  const others = items
    .filter((it) => (it.scaleType || '') !== '面部' && (it.scaleType || '') !== '舌部')
    .sort(sortFn)
  const groups: { key: string; label: string; items: TcmDetectionItemVo[] }[] = []
  if (face.length) groups.push({ key: 'face', label: '面部', items: face })
  if (tongue.length) groups.push({ key: 'tongue', label: '舌部', items: tongue })
  if (others.length) groups.push({ key: 'other', label: '其他', items: others })
  return groups
})

/** 调理建议分块：饮食/起居/运动/调护/音乐 */
const adviceGroups = computed(() => {
  const advices = parsed.value.advices
  if (!advices) return []
  const order: { key: keyof NonNullable<TcmReportJson['advices']>; label: string; icon: string }[] = [
    { key: 'food', label: '饮食', icon: '🍵' },
    { key: 'sleep', label: '起居', icon: '🌙' },
    { key: 'sport', label: '运动', icon: '🏃' },
    { key: 'treatment', label: '调护', icon: '🌿' },
    { key: 'music', label: '音乐', icon: '🎵' },
  ]
  return order
    .map((o) => ({ ...o, items: (advices[o.key] || []).filter((a) => a && a.advice) }))
    .filter((o) => o.items.length > 0)
})

const qrUrl = computed(() => absoluteUrl(service.value?.serviceQrImageUrl || service.value?.serviceQrImagePath))
const showQr = computed(() => !!qrUrl.value && !qrLoadFailed.value)

watch(qrUrl, () => {
  qrLoadFailed.value = false
})

onLoad((query) => {
  const recordId = Number(query?.recordId)
  loadReport(recordId)
})

async function loadReport(recordId: number) {
  if (!userStore.token || !recordId) {
    uni.showToast({ title: '报告参数无效', icon: 'none' })
    loading.value = false
    return
  }
  try {
    const [r, s] = await Promise.all([
      getTcmDetectionReport(userStore.token, recordId),
      getTcmCustomerService(userStore.token),
    ])
    report.value = r
    service.value = s
  } catch (e) {
    uni.showToast({ title: e instanceof Error ? e.message : '报告加载失败', icon: 'none' })
  } finally {
    loading.value = false
  }
}

function restart() {
  uni.redirectTo({ url: '/pages/tcm-detection/intro' })
}

function openDetail(itemCode: string) {
  const recordId = report.value?.recordId
  if (!recordId || !itemCode) return
  uni.navigateTo({
    url: `/pages/tcm-detection/detail?recordId=${recordId}&itemCode=${encodeURIComponent(itemCode)}`,
  })
}

function saveQrToAlbum() {
  const url = qrUrl.value
  if (!url) return
  uni.showLoading({ title: '保存中' })
  uni.downloadFile({
    url,
    success: (downloadRes) => {
      if (downloadRes.statusCode !== 200 || !downloadRes.tempFilePath) {
        uni.showToast({ title: '二维码下载失败', icon: 'none' })
        return
      }
      uni.saveImageToPhotosAlbum({
        filePath: downloadRes.tempFilePath,
        success: () => uni.showToast({ title: '已保存到相册', icon: 'none' }),
        fail: () => {
          uni.showModal({
            title: '保存失败',
            content: '请确认已授权保存到相册后重试。',
            showCancel: false,
          })
        },
      })
    },
    fail: () => uni.showToast({ title: '二维码下载失败', icon: 'none' }),
    complete: () => uni.hideLoading(),
  })
}

function onQrError() {
  qrLoadFailed.value = true
}
</script>

<style lang="scss" scoped>
.tcm-page { min-height: 100vh; padding: 18px 16px 32px; background: #f7fbf7; box-sizing: border-box; }
.empty-card, .score-card, .card { padding: 20px 18px; border-radius: 24px; background: #fff; border: 1px solid #edf1e7; box-sizing: border-box; }
.empty-card { text-align: center; color: #7a857a; }
.fail-card { display: flex; flex-direction: column; align-items: center; gap: 12px; }
.fail-title { font-size: 18px; font-weight: 900; color: #1f2a1f; }
.fail-desc { font-size: 14px; line-height: 1.6; color: #7a857a; }

.image-card { padding: 16px; }
.image-row { display: flex; gap: 12px; }
.image-col { flex: 1; display: flex; flex-direction: column; align-items: center; }
.upload-image { width: 100%; height: 150px; border-radius: 16px; background: #f5f8f2; }
.upload-image--empty { display: flex; align-items: center; justify-content: center; color: #9aa39a; font-size: 13px; }
.image-caption { margin-top: 8px; font-size: 13px; color: #607060; font-weight: 700; }

.score-card { margin-top: 14px; background: linear-gradient(180deg, #dcebc5 0%, #fff 100%); display: flex; flex-direction: column; align-items: center; }
.eyebrow { font-size: 13px; color: #5f8f4f; font-weight: 800; }
.score-row { margin-top: 14px; display: flex; align-items: baseline; }
.score { font-size: 60px; font-weight: 900; line-height: 1; color: #4f8f45; }
.score-unit { margin-left: 4px; font-size: 18px; font-weight: 800; color: #4f8f45; }
.score-label { margin-top: 6px; font-size: 14px; color: #607060; }
.constitution-wrap { margin-top: 16px; width: 100%; padding: 12px 16px; border-radius: 16px; background: rgba(255,255,255,.7); display: flex; flex-direction: column; align-items: center; }
.constitution-label { font-size: 13px; color: #607060; }
.constitution { margin-top: 4px; font-size: 22px; font-weight: 900; line-height: 1.3; color: #4f8f45; text-align: center; }

.card { margin-top: 14px; }
.section-title { display: block; font-size: 18px; color: #1f2a1f; font-weight: 900; }
.paragraph { display: block; margin-top: 10px; font-size: 14px; line-height: 1.8; color: #4c594c; }
.summary-card { border-color: #e5dff8; }

.symptom-list { margin-top: 10px; }
.symptom-line { display: flex; align-items: flex-start; margin-top: 8px; }
.symptom-dot { color: #5fa854; font-weight: 900; margin-right: 8px; line-height: 1.7; }
.symptom-text { flex: 1; font-size: 14px; line-height: 1.7; color: #4c594c; }

.risk-card { background: #fffaf0; border-color: #f0e6d6; }
.risk-card .section-title { color: #8a6a2d; }
.risk-card .paragraph { color: #8a6a2d; }

.syndrome-name { display: block; margin-top: 10px; font-size: 16px; font-weight: 800; color: #4f8f45; }

.feature-item { margin-top: 16px; padding-bottom: 14px; border-bottom: 1px solid #f0f2ee; }
.feature-item:active { opacity: .78; }
.feature-item:last-child { border-bottom: 0; padding-bottom: 0; }
.feature-head { display: flex; justify-content: space-between; align-items: center; }
.feature-name { font-size: 16px; color: #222; font-weight: 800; }
.feature-right { display: flex; align-items: center; gap: 8px; }
.feature-tag { padding: 2px 10px; border-radius: 10px; font-size: 12px; font-weight: 800; }
.feature-tag--normal { background: #eef6e8; color: #5fa854; }
.feature-tag--abnormal { background: #fdecea; color: #e25a4a; }
.feature-arrow { font-size: 22px; line-height: 1; color: #9ebc86; font-weight: 900; }
.feature-desc { display: block; margin-top: 8px; font-size: 13px; line-height: 1.6; color: #7a857a; }

.advice-group { margin-top: 16px; }
.advice-group:first-child { margin-top: 12px; }
.advice-group-head { display: flex; align-items: center; gap: 8px; }
.advice-group-icon { font-size: 16px; }
.advice-group-title { font-size: 15px; font-weight: 800; color: #1f2a1f; }
.advice-item { margin-top: 8px; padding: 12px 14px; border-radius: 14px; background: #fafdf8; border: 1px solid #edf1e7; }
.advice-title { display: block; font-size: 14px; font-weight: 700; color: #4f8f45; }
.advice-text { display: block; margin-top: 4px; font-size: 13px; line-height: 1.7; color: #4c594c; }

.info-line { display: block; margin-top: 10px; font-size: 14px; color: #607060; }

.notice-card { margin-top: 14px; padding: 16px 18px; border-radius: 18px; background: #fffaf0; border: 1px solid #f0e6d6; }
.notice-title { font-size: 15px; color: #8a6a2d; font-weight: 800; }
.notice-text { display: block; margin-top: 8px; font-size: 13px; line-height: 1.6; color: #8a6a2d; }

.primary-btn, .secondary-btn { margin-top: 16px; height: 46px; border-radius: 23px; font-size: 16px; font-weight: 900; }
.primary-btn { background: #9ebc86; color: #fff; }
.secondary-btn { background: #fff; color: #5f8f4f; border: 1px solid #9ebc86; }
.mask { position: fixed; inset: 0; background: rgba(0,0,0,.45); display: flex; align-items: flex-end; z-index: 99; }
.service-panel { width: 100%; padding: 24px 20px calc(24px + env(safe-area-inset-bottom)); border-radius: 24px 24px 0 0; background: #fff; box-sizing: border-box; display: flex; flex-direction: column; align-items: center; }
.panel-title { font-size: 20px; font-weight: 900; color: #1f2a1f; }
.panel-desc { margin-top: 8px; font-size: 13px; color: #7a857a; text-align: center; }
.qr-wrap { margin-top: 16px; width: 160px; height: 160px; border-radius: 12px; background: #f6f6f6; overflow: hidden; display: flex; align-items: center; justify-content: center; }
.qr { width: 160px; height: 160px; }
.qr-placeholder { margin-top: 16px; width: 160px; height: 80px; border-radius: 12px; background: #f6f6f6; color: #9aa39a; font-size: 13px; display: flex; align-items: center; justify-content: center; }
.service-line { margin-top: 10px; font-size: 15px; color: #384438; font-weight: 700; }
.panel-btn { width: 100%; }
.panel-save-btn { width: 100%; margin-top: 16px; background: #fff; }
</style>
