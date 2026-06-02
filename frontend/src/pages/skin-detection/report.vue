<template>
  <view class="skin-page">
    <view v-if="loading" class="empty-card">报告加载中...</view>
    <template v-else-if="report">
      <view class="score-card">
        <text class="eyebrow">AI 皮肤检测报告</text>
        <text class="score">{{ report.overallScore ?? '--' }}</text>
        <text class="score-label">综合肤况分</text>
        <text class="summary">{{ report.aiSummary || '暂无综合分析' }}</text>
      </view>

      <view class="card">
        <text class="section-title">6 项肤况明细</text>
        <view class="item" v-for="item in report.items" :key="item.itemCode" @click="openDetail(item.itemCode)">
          <view class="item-head">
            <text class="item-name">{{ item.itemName }}</text>
            <view class="item-score-wrap">
              <text class="item-score">{{ item.score ?? '--' }}分</text>
              <text class="item-arrow">›</text>
            </view>
          </view>
          <view class="bar"><view class="bar-inner" :style="{ width: `${Math.max(0, Math.min(100, item.score || 0))}%` }"></view></view>
          <text class="item-desc">{{ item.aiConclusion || item.resultText || item.level || '暂无说明' }}</text>
        </view>
      </view>

      <view class="card info-card">
        <text class="section-title">检测资料</text>
        <text class="info-line">姓名：{{ report.userName || '--' }}</text>
        <text class="info-line">年龄：{{ report.age || '--' }}</text>
        <text class="info-line">居住地：{{ report.residence || '--' }}</text>
      </view>

      <button class="primary-btn" @click="showService = true">定制护肤方案</button>
      <button class="secondary-btn" @click="restart">重新检测</button>
    </template>

    <view v-if="showService" class="mask" @click="showService = false">
      <view class="service-panel" @click.stop>
        <text class="panel-title">联系客服定制护肤方案</text>
        <text class="panel-desc">添加客服微信或拨打电话，获取更细致的护肤建议。</text>
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
import { getSkinCustomerService, getSkinDetectionReport, type SkinCustomerServiceVo, type SkinDetectionReportVo } from '@/api/skinDetection'
import { useUserStore } from '@/stores/user'

const userStore = useUserStore()
const loading = ref(true)
const report = ref<SkinDetectionReportVo | null>(null)
const service = ref<SkinCustomerServiceVo | null>(null)
const showService = ref(false)
const qrLoadFailed = ref(false)

const qrUrl = computed(() => {
  const raw = service.value?.serviceQrImageUrl || service.value?.serviceQrImagePath || ''
  if (!raw) return ''
  if (/^https?:\/\//i.test(raw)) return raw
  const path = raw.startsWith('/') ? raw : `/${raw}`
  return `${API_BASE_URL}${path}`
})
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
      getSkinDetectionReport(userStore.token, recordId),
      getSkinCustomerService(userStore.token),
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
  uni.redirectTo({ url: '/pages/skin-detection/camera' })
}

function openDetail(itemCode: string) {
  const recordId = report.value?.recordId
  if (!recordId || !itemCode) return
  uni.navigateTo({
    url: `/pages/skin-detection/detail?recordId=${recordId}&itemCode=${encodeURIComponent(itemCode)}`,
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
.skin-page { min-height: 100vh; padding: 18px 16px 32px; background: #f7fbf7; box-sizing: border-box; }
.empty-card, .score-card, .card { padding: 20px 18px; border-radius: 24px; background: #fff; border: 1px solid #edf1e7; box-sizing: border-box; }
.score-card { background: linear-gradient(180deg, #dcebc5 0%, #fff 100%); display: flex; flex-direction: column; align-items: center; }
.eyebrow { font-size: 13px; color: #5f8f4f; font-weight: 800; }
.score { margin-top: 12px; font-size: 64px; font-weight: 900; line-height: 1; color: #4f8f45; }
.score-label { margin-top: 6px; font-size: 14px; color: #607060; }
.summary { margin-top: 16px; font-size: 14px; line-height: 1.7; color: #384438; text-align: left; }
.card { margin-top: 14px; }
.section-title { display: block; font-size: 18px; color: #1f2a1f; font-weight: 900; }
.item { margin-top: 18px; padding-bottom: 16px; border-bottom: 1px solid #f0f2ee; }
.item:active { opacity: .78; }
.item:last-child { border-bottom: 0; padding-bottom: 0; }
.item-head { display: flex; justify-content: space-between; align-items: center; }
.item-name { font-size: 16px; color: #222; font-weight: 800; }
.item-score-wrap { display: flex; align-items: center; gap: 6px; }
.item-score { font-size: 15px; color: #5fa854; font-weight: 800; }
.item-arrow { font-size: 22px; line-height: 1; color: #9ebc86; font-weight: 900; }
.bar { margin-top: 10px; height: 8px; background: #edf1e7; border-radius: 8px; overflow: hidden; }
.bar-inner { height: 100%; background: #9ebc86; border-radius: 8px; }
.item-desc { display: block; margin-top: 8px; font-size: 13px; line-height: 1.6; color: #7a857a; }
.info-line { display: block; margin-top: 10px; font-size: 14px; color: #607060; }
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
