<template>
  <view class="tcm-page">
    <view class="intro-card">
      <text class="title">补充问诊</text>
      <text class="subtitle">请勾选近期符合自身情况的症状，可多选。结合望诊一起辨识，结果更贴合本人。</text>
    </view>

    <view v-if="questions.length" class="card">
      <view class="card-head">
        <text class="section-title">症状自评</text>
        <text class="selected-count">已选 {{ selectedCount }} 项</text>
      </view>
      <view class="option-list">
        <view
          v-for="(q, idx) in questions"
          :key="q.name + idx"
          class="option-item"
          :class="{ 'option-item--active': selected[idx] }"
          @click="toggle(idx)"
        >
          <view class="checkbox" :class="{ checked: selected[idx] }">
            <text v-if="selected[idx]" class="checkbox__tick">✓</text>
          </view>
          <view class="option-body">
            <text class="option-name">{{ q.name }}</text>
          </view>
        </view>
      </view>
    </view>

    <view v-else class="card empty-tip">
      <text class="empty-text">暂无需要补充的问诊题目，可直接生成报告。</text>
    </view>

    <view class="notice-card">
      <text class="notice-text">勾选越贴合本人，辨识结果越准确。若某项不确定，可不勾选。</text>
    </view>

    <button class="primary-btn" :disabled="submitting" @click="submit">
      {{ submitting ? '生成中...' : '提交并生成报告' }}
    </button>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { submitTcmInquiry, type TcmInquiryItem } from '@/api/tcmDetection'
import { useUserStore } from '@/stores/user'

const STORAGE_INQUIRY = 'tcm_detection_inquiry_questions'

const userStore = useUserStore()
const recordId = ref(0)
const questions = ref<TcmInquiryItem[]>([])
const selected = ref<boolean[]>([])
const submitting = ref(false)

const selectedCount = computed(() => selected.value.filter(Boolean).length)

onLoad((query) => {
  recordId.value = Number(query?.recordId) || 0
  try {
    const saved = uni.getStorageSync(STORAGE_INQUIRY)
    if (Array.isArray(saved)) {
      questions.value = saved.filter((q) => q && typeof q.name === 'string')
    }
  } catch {
    questions.value = []
  }
  selected.value = questions.value.map(() => false)
})

function toggle(idx: number) {
  const next = [...selected.value]
  next[idx] = !next[idx]
  selected.value = next
}

async function submit() {
  if (submitting.value) return
  if (!userStore.token || !recordId.value) {
    uni.showToast({ title: '问诊参数无效', icon: 'none' })
    return
  }
  const answers: TcmInquiryItem[] = questions.value.filter((_, idx) => selected.value[idx])
  submitting.value = true
  uni.showLoading({ title: '生成报告中', mask: true })
  try {
    const res = await submitTcmInquiry(userStore.token, recordId.value, { answers })
    uni.removeStorageSync(STORAGE_INQUIRY)
    if (res.status === 'failed') {
      throw new Error(res.message || '体质辨识失败，请重试')
    }
    uni.redirectTo({ url: `/pages/tcm-detection/report?recordId=${res.recordId || recordId.value}` })
  } catch (e) {
    uni.showModal({
      title: '提交失败',
      content: e instanceof Error ? e.message : '请稍后重试',
      showCancel: false,
    })
  } finally {
    uni.hideLoading()
    submitting.value = false
  }
}
</script>

<style lang="scss" scoped>
.tcm-page { min-height: 100vh; padding: 18px 16px 32px; background: #f7fbf7; box-sizing: border-box; }
.intro-card { padding: 22px 20px; border-radius: 22px; background: linear-gradient(180deg, #dcebc5 0%, #ffffff 100%); border: 1px solid #e4edd6; display: flex; flex-direction: column; }
.title { font-size: 22px; font-weight: 900; color: #1f2a1f; }
.subtitle { margin-top: 10px; font-size: 14px; line-height: 1.7; color: #607060; }
.card { margin-top: 14px; padding: 18px; border-radius: 20px; background: #fff; border: 1px solid #edf1e7; box-sizing: border-box; }
.card-head { display: flex; justify-content: space-between; align-items: center; }
.section-title { font-size: 17px; color: #1f2a1f; font-weight: 800; }
.selected-count { font-size: 13px; color: #5fa854; font-weight: 800; }
.option-list { margin-top: 8px; }
.option-item { display: flex; align-items: center; padding: 14px 12px; margin-top: 10px; border-radius: 14px; border: 1px solid #edf1e7; background: #fafdf8; }
.option-item--active { border-color: #9ebc86; background: #eef6e8; }
.checkbox { width: 22px; height: 22px; border-radius: 6px; border: 2px solid #c3cfb8; background: #fff; flex-shrink: 0; display: flex; align-items: center; justify-content: center; }
.checkbox.checked { background: #5fa854; border-color: #5fa854; }
.checkbox__tick { font-size: 14px; color: #fff; font-weight: 900; line-height: 1; }
.option-body { flex: 1; margin-left: 12px; display: flex; flex-direction: column; }
.option-name { font-size: 15px; color: #1f2a1f; font-weight: 700; }
.option-value { margin-top: 4px; font-size: 13px; line-height: 1.5; color: #7a857a; }
.empty-tip { display: flex; align-items: center; justify-content: center; }
.empty-text { font-size: 14px; color: #7a857a; }
.notice-card { margin-top: 14px; padding: 16px 18px; border-radius: 18px; background: #fffaf0; border: 1px solid #f0e6d6; }
.notice-text { font-size: 13px; line-height: 1.6; color: #8a6a2d; }
.primary-btn { margin-top: 24px; height: 48px; border-radius: 24px; background: #9ebc86; color: #fff; font-size: 16px; font-weight: 800; }
.primary-btn[disabled] { opacity: .6; }
</style>
