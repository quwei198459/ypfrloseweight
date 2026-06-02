<template>
  <view class="skin-page">
    <view class="hero-card">
      <text class="eyebrow">AI 皮肤检测</text>
      <text class="title">拍一张正脸照，生成专属肤况报告</text>
      <text class="subtitle">检测斑点、毛孔、肤质（油干性）、皱纹、黑头、痘痘 6 项肤况，辅助了解当前肌肤状态。</text>
    </view>

    <view class="quota-card">
      <view class="quota-head">
        <text class="section-title">检测次数</text>
        <text class="quota-status">{{ quotaText }}</text>
      </view>
      <text class="quota-desc">{{ quotaMessage }}</text>
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
      <text class="notice-text">本报告仅作为日常护肤参考，不作为医疗诊断依据。如存在严重皮肤问题，请咨询专业医生。</text>
    </view>

    <button class="primary-btn" :disabled="loading" @click="goNext">开始检测</button>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { getSkinDetectionQuota, type SkinDetectionQuotaVo } from '@/api/skinDetection'
import { useUserStore } from '@/stores/user'

const userStore = useUserStore()
const loading = ref(false)
const quota = ref<SkinDetectionQuotaVo | null>(null)

const steps = [
  { no: '1', title: '确认资料', desc: '填写姓名、性别、出生日期和居住地' },
  { no: '2', title: '按提示拍照', desc: '保持正脸、光线充足、避免遮挡' },
  { no: '3', title: '获取报告', desc: '查看综合分和 6 项肤况明细' },
]

const quotaText = computed(() => {
  if (!quota.value) return '查询中'
  return quota.value.allowed ? `剩余 ${quota.value.remainingTimes} 次` : '暂不可用'
})

const quotaMessage = computed(() => quota.value?.message || '正在查询当前账号的皮肤检测资格')

onShow(() => {
  loadQuota()
})

async function loadQuota() {
  if (!userStore.token) {
    quota.value = null
    return
  }
  loading.value = true
  try {
    quota.value = await getSkinDetectionQuota(userStore.token)
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
  uni.navigateTo({ url: '/pages/skin-detection/profile' })
}
</script>

<style lang="scss" scoped>
.skin-page { min-height: 100vh; padding: 18px 16px 32px; background: #f7fbf7; box-sizing: border-box; }
.hero-card { padding: 24px 20px; border-radius: 24px; background: linear-gradient(180deg, #dcebc5 0%, #ffffff 100%); border: 1px solid #e4edd6; display: flex; flex-direction: column; }
.eyebrow { font-size: 13px; color: #5f8f4f; font-weight: 700; }
.title { margin-top: 10px; font-size: 24px; line-height: 1.25; color: #1f2a1f; font-weight: 900; }
.subtitle { margin-top: 12px; font-size: 14px; line-height: 1.7; color: #607060; }
.quota-card, .card, .notice-card { margin-top: 14px; padding: 18px; border-radius: 20px; background: #fff; border: 1px solid #edf1e7; box-sizing: border-box; }
.quota-head { display: flex; justify-content: space-between; align-items: center; }
.section-title { font-size: 17px; color: #1f2a1f; font-weight: 800; }
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
