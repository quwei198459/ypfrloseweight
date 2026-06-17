<template>
  <view class="tcm-page">
    <view class="loading-card">
      <view class="scan-box">
        <view class="scan-ring scan-ring--one"></view>
        <view class="scan-ring scan-ring--two"></view>
        <view class="face-circle">
          <view class="face-eye face-eye--left"></view>
          <view class="face-eye face-eye--right"></view>
          <view class="face-mouth"></view>
        </view>
        <view class="scan-line"></view>
        <view class="scan-dot scan-dot--one"></view>
        <view class="scan-dot scan-dot--two"></view>
        <view class="scan-dot scan-dot--three"></view>
      </view>
      <text class="title">正在生成体质报告</text>
      <text class="subtitle">AI 正在通过舌象与面象进行望诊辨识，分析体质偏向并生成调理建议，请稍候。</text>
      <view class="step-list">
        <view class="step step--active">识别舌象与面象</view>
        <view class="step step--active step--delay1">望诊特征辨识</view>
        <view class="step step--active step--delay2">生成调理建议</view>
      </view>
      <view class="progress"><view class="progress-inner"></view></view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { createTcmDetectionRecord, type TcmDetectionScene } from '@/api/tcmDetection'
import { useUserStore } from '@/stores/user'
import { readLocalFileAsBase64 } from '@/utils/file'

const STORAGE_PROFILE = 'tcm_detection_profile'
const STORAGE_SCENE = 'tcm_detection_scene'
const STORAGE_TONGUE_IMAGE = 'tcm_detection_tongue_image_path'
const STORAGE_FACE_IMAGE = 'tcm_detection_face_image_path'
const STORAGE_INQUIRY = 'tcm_detection_inquiry_questions'
const submitting = ref(false)
const userStore = useUserStore()

onMounted(() => {
  submitDetection()
})

async function submitDetection() {
  if (submitting.value) return
  submitting.value = true
  try {
    if (!userStore.token) throw new Error('请先登录')
    const tongueImagePath = uni.getStorageSync(STORAGE_TONGUE_IMAGE)
    if (!tongueImagePath || typeof tongueImagePath !== 'string') throw new Error('请先上传舌象照片')
    const faceImagePath = uni.getStorageSync(STORAGE_FACE_IMAGE)
    if (!faceImagePath || typeof faceImagePath !== 'string') throw new Error('请先上传面象照片')
    const profile = uni.getStorageSync(STORAGE_PROFILE) || {}
    const savedScene = uni.getStorageSync(STORAGE_SCENE)
    const scene: TcmDetectionScene | undefined = savedScene === 1 || savedScene === 2 ? savedScene : undefined
    const [tongueImageBase64, faceImageBase64] = await Promise.all([
      readLocalFileAsBase64(tongueImagePath),
      readLocalFileAsBase64(faceImagePath),
    ])
    const res = await createTcmDetectionRecord(userStore.token, {
      ...(typeof profile === 'object' ? profile : {}),
      ...(scene ? { scene } : {}),
      tongueImageBase64,
      faceImageBase64,
    })
    if (res.status === 'pending_inquiry') {
      // 问诊模式：暂存问诊题目，跳问诊页
      uni.setStorageSync(STORAGE_INQUIRY, res.inquiryQuestions || [])
      uni.redirectTo({ url: `/pages/tcm-detection/inquiry?recordId=${res.recordId}` })
      return
    }
    if (res.status === 'failed') {
      throw new Error(res.message || '体质辨识失败，请重试')
    }
    // status === 'success'
    uni.redirectTo({ url: `/pages/tcm-detection/report?recordId=${res.recordId}` })
  } catch (e) {
    uni.showModal({
      title: '检测失败',
      content: e instanceof Error ? e.message : '请稍后重试',
      showCancel: false,
      success: () => uni.navigateBack(),
    })
  } finally {
    submitting.value = false
  }
}
</script>

<style lang="scss" scoped>
.tcm-page { min-height: 100vh; padding: 28px 16px; background: linear-gradient(180deg, #f7fbf7 0%, #f3f0fb 100%); box-sizing: border-box; display: flex; align-items: center; }
.loading-card { width: 100%; padding: 34px 20px; border-radius: 28px; background: rgba(255,255,255,.96); border: 1px solid #edf1e7; display: flex; flex-direction: column; align-items: center; box-shadow: 0 14px 38px rgba(119,142,105,.12); }
.scan-box { position: relative; width: 210px; height: 210px; border-radius: 50%; background: radial-gradient(circle at center, #ffffff 0%, #eef6e8 64%, #efe8ff 100%); overflow: hidden; display: flex; align-items: center; justify-content: center; }
.scan-ring { position: absolute; border-radius: 50%; border: 1px solid rgba(158,188,134,.42); animation: pulse 2.4s ease-out infinite; }
.scan-ring--one { width: 132px; height: 132px; }
.scan-ring--two { width: 172px; height: 172px; animation-delay: .8s; }
.face-circle { position: relative; width: 108px; height: 136px; border: 2px solid #9ebc86; border-radius: 50%; background: rgba(255,255,255,.32); }
.face-eye { position: absolute; top: 46px; width: 8px; height: 8px; border-radius: 50%; background: #9ebc86; animation: blink 2.8s infinite; }
.face-eye--left { left: 32px; }
.face-eye--right { right: 32px; }
.face-mouth { position: absolute; left: 39px; bottom: 36px; width: 30px; height: 14px; border-bottom: 2px solid #9ebc86; border-radius: 0 0 20px 20px; }
.scan-line { position: absolute; left: 24px; right: 24px; height: 3px; background: linear-gradient(90deg, transparent, #5fa854, #bca7ef, transparent); box-shadow: 0 0 16px rgba(95,168,84,.75); animation: scan 1.6s linear infinite; }
.scan-dot { position: absolute; width: 8px; height: 8px; border-radius: 50%; background: #bca7ef; opacity: .76; animation: floatDot 2.2s ease-in-out infinite; }
.scan-dot--one { left: 38px; top: 64px; }
.scan-dot--two { right: 42px; top: 112px; animation-delay: .45s; }
.scan-dot--three { left: 86px; bottom: 36px; animation-delay: .9s; }
.title { margin-top: 26px; font-size: 22px; font-weight: 900; color: #1f2a1f; }
.subtitle { margin-top: 12px; text-align: center; font-size: 14px; line-height: 1.7; color: #607060; }
.step-list { margin-top: 20px; width: 100%; display: grid; gap: 8px; }
.step { height: 32px; border-radius: 16px; background: #f5f8f2; color: #7a857a; font-size: 13px; display: flex; align-items: center; justify-content: center; animation: stepGlow 2.4s ease-in-out infinite; }
.step--delay1 { animation-delay: .4s; }
.step--delay2 { animation-delay: .8s; }
.progress { margin-top: 24px; width: 220px; height: 8px; border-radius: 8px; background: #edf1e7; overflow: hidden; }
.progress-inner { width: 52%; height: 100%; border-radius: 8px; background: linear-gradient(90deg, #9ebc86, #bca7ef); animation: progress 1.2s ease-in-out infinite alternate; }
@keyframes scan { from { top: 32px; } to { top: 174px; } }
@keyframes progress { from { transform: translateX(-70px); } to { transform: translateX(160px); } }
@keyframes pulse { 0% { transform: scale(.82); opacity: .8; } 70% { transform: scale(1.14); opacity: .12; } 100% { transform: scale(1.18); opacity: 0; } }
@keyframes blink { 0%, 88%, 100% { transform: scaleY(1); } 92%, 96% { transform: scaleY(.18); } }
@keyframes floatDot { 0%, 100% { transform: translateY(0); opacity: .35; } 50% { transform: translateY(-8px); opacity: .9; } }
@keyframes stepGlow { 0%, 100% { background: #f5f8f2; color: #7a857a; } 50% { background: #eef6e8; color: #5f8f4f; } }
</style>
