<template>
  <view class="plan-bmi-card">
    <view class="bmi-top">
      <image class="bmi-mascot" :src="mascotSrc" mode="aspectFill" />
      <view class="bmi-main">
        <view class="bmi-header-row">
          <text class="bmi-value-text">当前BMI: {{ bmiValue }}</text>
          <text class="bmi-status-tag">({{ bmiLevel }})</text>
        </view>
        <view class="bmi-progress-bar">
          <view class="bmi-scale-labels">
            <text class="scale-lab" :class="{ 'scale-lab-strong': bmiLevel === '偏低' }">偏低</text>
            <text class="scale-lab" :class="{ 'scale-lab-strong': bmiLevel === '标准' }">标准</text>
            <text class="scale-lab" :class="{ 'scale-lab-strong': bmiLevel === '超重' }">超重</text>
            <text class="scale-lab" :class="{ 'scale-lab-strong': bmiLevel === '肥胖' }">肥胖</text>
          </view>
          <view class="bmi-track-wrap">
            <view class="bmi-segment-track">
              <view class="seg seg-u" />
              <view class="seg seg-n" />
              <view class="seg seg-ow" />
              <view class="seg seg-ob" />
            </view>
            <view class="bmi-marker" :style="{ left: markerLeft }" />
          </view>
          <view class="bmi-threshold-row">
            <text class="thr" v-for="(t, i) in thresholds" :key="i">{{ t }}</text>
          </view>
        </view>
      </view>
    </view>
    <text class="bmi-description-text">{{ bmiDescription }}</text>
  </view>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  bmiValue: { type: Number, required: true },
  bmiLevel: { type: String, required: true },
  bmiDescription: { type: String, required: true },
  thresholds: {
    type: Array,
    default: () => ['18.5', '24', '30'],
  },
  mascotSrc: { type: String, default: '/static/plan/weekly-boy.png' },
})

/** 在 16–34 的 BMI 轴上映射指示点位置（示意） */
const markerLeft = computed(() => {
  const b = props.bmiValue
  if (!Number.isFinite(b) || b <= 0) return '38%'
  const t = ((b - 16) / (34 - 16)) * 100
  return `${Math.min(96, Math.max(4, t))}%`
})
</script>

<style scoped>
.plan-bmi-card {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
  padding: 32rpx;
  background: #ffffff;
  border-radius: 32rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.06);
}

.bmi-top {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
  gap: 20rpx;
}

.bmi-mascot {
  width: 96rpx;
  height: 96rpx;
  border-radius: 50%;
  flex-shrink: 0;
  background: #eef3ee;
}

.bmi-main {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.bmi-header-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  flex-wrap: wrap;
  gap: 12rpx;
}

.bmi-value-text {
  font-size: 30rpx;
  font-weight: 600;
  color: #1a1a1a;
}

.bmi-status-tag {
  font-size: 28rpx;
  font-weight: 600;
  color: #e65100;
}

.bmi-progress-bar {
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.bmi-scale-labels {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
}

.scale-lab {
  font-size: 20rpx;
  color: #888888;
}

.scale-lab-strong {
  font-weight: 700;
  color: #1a1a1a;
}

.bmi-track-wrap {
  position: relative;
  height: 16rpx;
}

.bmi-segment-track {
  display: flex;
  flex-direction: row;
  gap: 4rpx;
  height: 16rpx;
}

.seg {
  flex: 1;
  border-radius: 8rpx;
}

.seg-u {
  background: #b3e5fc;
}

.seg-n {
  background: #c8e6c9;
}

.seg-ow {
  background: #ffcc80;
}

.seg-ob {
  background: #ffab91;
}

.bmi-marker {
  position: absolute;
  top: -6rpx;
  width: 0;
  height: 0;
  margin-left: -10rpx;
  border-left: 10rpx solid transparent;
  border-right: 10rpx solid transparent;
  border-top: 14rpx solid #2e7d32;
}

.bmi-threshold-row {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  padding: 0 16rpx;
}

.thr {
  font-size: 20rpx;
  color: #999999;
}

.bmi-description-text {
  font-size: 24rpx;
  line-height: 1.45;
  color: #555555;
}
</style>
