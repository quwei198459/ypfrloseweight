<template>
  <view class="tcm-page">
    <view class="hero-card">
      <text class="eyebrow">中医体检 · AI 舌诊面诊</text>
      <text class="title">拍舌象 + 面象，生成专属体质报告</text>
      <text class="subtitle">通过 AI 舌诊、面诊进行望诊辨识，了解当前体质偏向与典型症状，并获取个性化调理建议。</text>
    </view>

    <view class="quota-card">
      <view class="quota-head">
        <text class="section-title">检测次数</text>
        <text class="quota-status">{{ quotaText }}</text>
      </view>
      <text class="quota-desc">{{ quotaMessage }}</text>
    </view>

    <view class="card">
      <text class="section-title">检测方式</text>
      <text class="section-sub">选择报告生成方式，可随时更改</text>
      <view class="scene-list">
        <view
          v-for="opt in sceneOptions"
          :key="opt.value"
          class="scene-item"
          :class="{ 'scene-item--active': scene === opt.value }"
          @click="scene = opt.value"
        >
          <view class="scene-radio" :class="{ checked: scene === opt.value }">
            <view v-if="scene === opt.value" class="scene-radio__dot"></view>
          </view>
          <view class="scene-body">
            <view class="scene-title-row">
              <text class="scene-title">{{ opt.title }}</text>
              <text v-if="opt.tag" class="scene-tag">{{ opt.tag }}</text>
            </view>
            <text class="scene-desc">{{ opt.desc }}</text>
          </view>
        </view>
      </view>
    </view>

    <view class="card">
      <text class="section-title">检测流程</text>
      <view class="steps">
        <view class="step" v-for="item in steps" :key="item.no">
          <view class="step-no">{{ item.no }}</view>
          <view class="step-body">
            <text class="step-title">{{ item.title }}</text>
            <text class="step-desc">{{ item.desc }}</text>
          </view>
        </view>
      </view>
    </view>

    <view class="notice-card">
      <text class="notice-title">温馨提示</text>
      <text class="notice-text">本报告基于中医体质辨识理论，仅作为日常养生调理参考，不作为医疗诊断依据。如有不适，请咨询专业中医师。</text>
    </view>

    <button class="primary-btn" :disabled="loading" @click="goNext">开始检测</button>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { getTcmDetectionQuota, type TcmDetectionQuotaVo, type TcmDetectionScene } from '@/api/tcmDetection'
import { useUserStore } from '@/stores/user'

const STORAGE_SCENE = 'tcm_detection_scene'
const userStore = useUserStore()
const loading = ref(false)
const quota = ref<TcmDetectionQuotaVo | null>(null)
const scene = ref<TcmDetectionScene>(2)

const sceneOptions: { value: TcmDetectionScene; title: string; tag?: string; desc: string }[] = [
  { value: 2, title: '快速出报告', tag: '推荐', desc: '上传舌象、面象后直接生成体质报告，无需额外作答。' },
  { value: 1, title: '问诊更准', desc: '在望诊基础上增加几道症状问诊题，辨识结果更贴合本人。' },
]

const steps = [
  { no: '1', title: '确认资料', desc: '填写姓名、性别、出生日期和居住地' },
  { no: '2', title: '依次拍舌象和面象', desc: '先拍舌头，再拍面部，光线充足、避免遮挡' },
  { no: '3', title: '获取报告', desc: '查看主体质、综合分、望诊特征与调理建议' },
]

const quotaText = computed(() => {
  if (!quota.value) return '查询中'
  return quota.value.allowed ? `剩余 ${quota.value.remainingTimes} 次` : '暂不可用'
})

const quotaMessage = computed(() => quota.value?.message || '正在查询当前账号的中医体检资格')

onShow(() => {
  loadQuota()
  try {
    const saved = uni.getStorageSync(STORAGE_SCENE)
    if (saved === 1 || saved === 2) scene.value = saved
  } catch {
    /* ignore */
  }
})

async function loadQuota() {
  if (!userStore.token) {
    quota.value = null
    return
  }
  loading.value = true
  try {
    quota.value = await getTcmDetectionQuota(userStore.token)
  } catch (e) {
    uni.showToast({ title: e instanceof Error ? e.message : '次数查询失败', icon: 'none' })
  } finally {
    loading.value = false
  }
}

function goNext() {
  if (!userStore.token) {
    uni.navigateTo({ url: '/pages/login/index' })
    return
  }
  if (quota.value && !quota.value.allowed) {
    uni.showToast({ title: quota.value.message || '暂不可检测', icon: 'none' })
    return
  }
  uni.setStorageSync(STORAGE_SCENE, scene.value)
  uni.navigateTo({ url: '/pages/tcm-detection/profile' })
}
</script>

<style lang="scss" scoped>
.tcm-page { min-height: 100vh; padding: 18px 16px 32px; background: #f7fbf7; box-sizing: border-box; }
.hero-card { padding: 24px 20px; border-radius: 24px; background: linear-gradient(180deg, #dcebc5 0%, #ffffff 100%); border: 1px solid #e4edd6; display: flex; flex-direction: column; }
.eyebrow { font-size: 13px; color: #5f8f4f; font-weight: 700; }
.title { margin-top: 10px; font-size: 24px; line-height: 1.25; color: #1f2a1f; font-weight: 900; }
.subtitle { margin-top: 12px; font-size: 14px; line-height: 1.7; color: #607060; }
.quota-card, .card, .notice-card { margin-top: 14px; padding: 18px; border-radius: 20px; background: #fff; border: 1px solid #edf1e7; box-sizing: border-box; }
.quota-head { display: flex; justify-content: space-between; align-items: center; }
.section-title { font-size: 17px; color: #1f2a1f; font-weight: 800; }
.section-sub { display: block; margin-top: 6px; font-size: 13px; color: #7a857a; }
.scene-list { margin-top: 14px; display: flex; flex-direction: column; gap: 12px; }
.scene-item { display: flex; align-items: flex-start; padding: 14px; border-radius: 16px; border: 1px solid #edf1e7; background: #fafdf8; }
.scene-item--active { border-color: #9ebc86; background: #eef6e8; }
.scene-radio { width: 20px; height: 20px; border-radius: 50%; border: 2px solid #c3cfb8; background: #fff; flex-shrink: 0; margin-top: 2px; display: flex; align-items: center; justify-content: center; }
.scene-radio.checked { border-color: #5fa854; }
.scene-radio__dot { width: 10px; height: 10px; border-radius: 50%; background: #5fa854; }
.scene-body { flex: 1; margin-left: 12px; display: flex; flex-direction: column; }
.scene-title-row { display: flex; align-items: center; gap: 8px; }
.scene-title { font-size: 15px; color: #1f2a1f; font-weight: 800; }
.scene-tag { padding: 1px 8px; border-radius: 10px; background: #5fa854; color: #fff; font-size: 11px; font-weight: 700; }
.scene-desc { margin-top: 6px; font-size: 13px; line-height: 1.6; color: #7a857a; }
.quota-status { font-size: 14px; color: #5fa854; font-weight: 800; }
.quota-desc, .notice-text { margin-top: 8px; font-size: 13px; line-height: 1.6; color: #7a857a; }
.steps { margin-top: 14px; }
.step { display: flex; margin-top: 14px; }
.step-no { width: 28px; height: 28px; border-radius: 50%; background: #d5e7b1; border: 1px solid #9ebc86; color: #4b5b2d; display: flex; align-items: center; justify-content: center; font-weight: 800; }
.step-body { flex: 1; margin-left: 12px; display: flex; flex-direction: column; }
.step-title { font-size: 15px; color: #222; font-weight: 700; }
.step-desc { margin-top: 4px; font-size: 13px; color: #7a857a; }
.notice-card { background: #fffaf0; border-color: #f0e6d6; }
.notice-title { font-size: 15px; color: #8a6a2d; font-weight: 800; }
.primary-btn { margin-top: 24px; height: 48px; border-radius: 24px; background: #9ebc86; color: #fff; font-size: 16px; font-weight: 800; }
.primary-btn[disabled] { opacity: .6; }
</style>
