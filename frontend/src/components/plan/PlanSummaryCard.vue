<template>
  <view class="plan-summary-card">
    <view class="metrics-row">
      <view class="metric plan-duration">
        <text class="metric-label">计划周期</text>
        <text class="metric-value">{{ duration }}{{ durationUnit }}</text>
      </view>
      <view class="metric plan-weight-range">
        <text class="metric-label">减重目标</text>
        <text class="metric-value">{{ startWeight }}-{{ targetWeight }}{{ unit }}</text>
      </view>
    </view>
    <view class="weekly-weight-loss">
      <view class="illus-placeholder image-placeholder">
        <text class="placeholder-text">image-placeholder</text>
      </view>
      <view class="weekly-bubble">
        <view class="weekly-text-row">
          <text class="weekly-prefix">每周减重 </text>
          <text class="weekly-num">{{ weeklyLoss }}</text>
          <text class="weekly-suffix"> {{ unit }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup>
defineProps({
  duration: { type: Number, required: true },
  startWeight: { type: Number, required: true },
  targetWeight: { type: Number, required: true },
  weeklyLoss: { type: Number, required: true },
  unit: { type: String, default: '斤' },
  durationUnit: { type: String, default: '周' },
})
</script>

<style scoped>
.plan-summary-card {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
}

.metrics-row {
  display: flex;
  flex-direction: row;
  gap: 20rpx;
}

.metric {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 12rpx;
  padding: 28rpx 24rpx;
  background: #ffffff;
  border-radius: 28rpx;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.04);
}

.metric-label {
  font-size: 24rpx;
  color: #888888;
}

.metric-value {
  font-size: 40rpx;
  font-weight: 700;
  color: #1a1a1a;
}

.weekly-weight-loss {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 20rpx;
}

.image-placeholder {
  width: 112rpx;
  height: 96rpx;
  border-radius: 24rpx;
  background: #eef3ee;
  border: 1rpx solid #c8d8c8;
  display: flex;
  align-items: center;
  justify-content: center;
}

.placeholder-text {
  font-size: 20rpx;
  color: #7a8f7a;
}

.weekly-bubble {
  flex: 1;
  background: #e3f2e0;
  border-radius: 32rpx;
  padding: 24rpx 28rpx;
}

.weekly-text-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  flex-wrap: wrap;
}

.weekly-prefix,
.weekly-suffix {
  font-size: 28rpx;
  color: #333333;
}

.weekly-num {
  font-size: 32rpx;
  font-weight: 700;
  color: #2e7d32;
}
</style>
