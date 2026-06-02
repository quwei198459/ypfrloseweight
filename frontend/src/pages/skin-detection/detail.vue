<template>
  <view class="skin-detail-page">
    <view v-if="loading" class="empty-card">详情加载中...</view>
    <template v-else-if="item">
      <view class="hero-card">
        <text class="eyebrow">肤况单项报告</text>
        <view class="hero-main">
          <view>
            <text class="item-title">{{ item.itemName }}</text>
            <text class="item-subtitle">{{ levelLabel }}</text>
          </view>
          <view class="score-badge">
            <text class="score-value">{{ item.score ?? '--' }}</text>
            <text class="score-unit">分</text>
          </view>
        </view>
        <view class="score-bar">
          <view class="score-bar__inner" :style="{ width: scorePercent }"></view>
        </view>
      </view>

      <view class="card">
        <text class="section-title">诊断结论</text>
        <text class="paragraph">{{ item.aiConclusion || item.resultText || '暂无诊断结论' }}</text>
      </view>

      <view class="card">
        <text class="section-title">产生原因</text>
        <text class="paragraph">{{ item.aiReason || fallbackReason }}</text>
      </view>

      <view class="card advice-card">
        <text class="section-title">护理建议</text>
        <text class="paragraph">{{ item.aiCareAdvice || fallbackAdvice }}</text>
      </view>

    </template>
    <view v-else class="empty-card">未找到检测项详情</view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { getSkinDetectionReport, type SkinDetectionItemVo } from '@/api/skinDetection'
import { useUserStore } from '@/stores/user'

const userStore = useUserStore()
const loading = ref(true)
const item = ref<SkinDetectionItemVo | null>(null)

const scorePercent = computed(() => {
  const score = Math.max(0, Math.min(100, item.value?.score || 0))
  return `${score}%`
})

const levelLabel = computed(() => levelText(item.value?.level || ''))

const fallbackReason = computed(() => {
  const name = item.value?.itemName || '该项'
  return `根据当前检测数据，${name}状态需要结合清洁、保湿、防晒、作息和环境因素综合判断。`
})

const fallbackAdvice = computed(() => {
  const name = item.value?.itemName || '该项'
  return `建议围绕${name}做好温和清洁、基础保湿和日间防晒，避免频繁刺激皮肤。如需更细致方案，可联系客服定制。`
})

onLoad(async (query) => {
  const recordId = Number(query?.recordId)
  const itemCode = String(query?.itemCode || '')
  if (!userStore.token || !recordId || !itemCode) {
    uni.showToast({ title: '详情参数无效', icon: 'none' })
    loading.value = false
    return
  }
  try {
    const report = await getSkinDetectionReport(userStore.token, recordId)
    item.value = report.items.find((entry) => entry.itemCode === itemCode) || null
  } catch (e) {
    uni.showToast({ title: e instanceof Error ? e.message : '详情加载失败', icon: 'none' })
  } finally {
    loading.value = false
  }
})

function levelText(level: string) {
  const map: Record<string, string> = {
    severe: '严重',
    moderately: '中度',
    lightly: '轻度',
    none: '无明显问题',
    oil: '油性',
    dry: '干性',
    mid: '中性',
    mix: '混合性',
    mid_oil: '中性偏油',
    mid_dry: '中性偏干',
  }
  return map[level] || level || '暂无等级'
}
</script>

<style lang="scss" scoped>
.skin-detail-page {
  min-height: 100vh;
  padding: 18px 16px 32px;
  background: linear-gradient(180deg, #f7fbf7 0%, #f3f0fb 100%);
  box-sizing: border-box;
}
.empty-card,
.hero-card,
.card {
  padding: 20px 18px;
  border-radius: 24px;
  background: rgba(255, 255, 255, 0.96);
  border: 1px solid #edf1e7;
  box-sizing: border-box;
  box-shadow: 0 10px 30px rgba(119, 142, 105, 0.08);
}
.hero-card {
  background: linear-gradient(135deg, #dcebc5 0%, #efe8ff 100%);
}
.eyebrow {
  font-size: 13px;
  color: #5f8f4f;
  font-weight: 800;
}
.hero-main {
  margin-top: 16px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 14px;
}
.item-title {
  display: block;
  font-size: 26px;
  line-height: 1.2;
  color: #1f2a1f;
  font-weight: 900;
}
.item-subtitle {
  display: block;
  margin-top: 6px;
  font-size: 14px;
  color: #607060;
}
.score-badge {
  width: 82px;
  height: 82px;
  border-radius: 50%;
  background: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 10px 24px rgba(95, 143, 79, 0.16);
}
.score-value {
  font-size: 34px;
  line-height: 1;
  font-weight: 900;
  color: #5fa854;
}
.score-unit {
  margin-left: 2px;
  font-size: 13px;
  line-height: 1;
  color: #5fa854;
  font-weight: 800;
}
.score-bar {
  margin-top: 18px;
  height: 9px;
  border-radius: 9px;
  background: rgba(255, 255, 255, 0.65);
  overflow: hidden;
}
.score-bar__inner {
  height: 100%;
  border-radius: 9px;
  background: linear-gradient(90deg, #9ebc86, #bca7ef);
}
.card {
  margin-top: 14px;
}
.section-title {
  display: block;
  font-size: 17px;
  color: #1f2a1f;
  font-weight: 900;
}
.paragraph {
  display: block;
  margin-top: 10px;
  font-size: 14px;
  line-height: 1.8;
  color: #4c594c;
}
.advice-card {
  border-color: #e5dff8;
}

</style>
