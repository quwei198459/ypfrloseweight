<template>
  <view class="plan-bmi-card">
    <view class="bmi-header-row">
      <text class="bmi-value-text">当前BMI: {{ bmiValue }}</text>
      <text class="bmi-status-tag">({{ bmiLevel }})</text>
    </view>
    <view class="bmi-progress-bar">
      <view class="bmi-scale-labels">
        <text class="scale-lab">偏低</text>
        <text class="scale-lab">标准</text>
        <text class="scale-lab scale-lab-strong">超重</text>
        <text class="scale-lab">肥胖</text>
      </view>
      <view class="bmi-segment-track">
        <view class="seg seg-u" />
        <view class="seg seg-n" />
        <view class="seg seg-ow" />
        <view class="seg seg-ob" />
      </view>
      <view class="bmi-threshold-row">
        <text class="thr" v-for="(t, i) in thresholds" :key="i">{{ t }}</text>
      </view>
    </view>
    <text class="bmi-description-text">{{ bmiDescription }}</text>
  </view>
</template>

<script setup>
defineProps({
  bmiValue: { type: Number, required: true },
  bmiLevel: { type: String, required: true },
  bmiDescription: { type: String, required: true },
  thresholds: {
    type: Array,
    default: () => ['18.5', '24', '30'],
  },
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

.bmi-header-row {
  display: flex;
  flex-direction: row;
  align-items: center;
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
