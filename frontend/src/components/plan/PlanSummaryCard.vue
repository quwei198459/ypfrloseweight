<template>
  <view class="plan-summary-card">
    <view class="metrics-row">
      <view class="metric">
        <text class="metric-label">计划周期</text>
        <text class="metric-value">{{ duration }}{{ durationUnit }}</text>
      </view>
      <view class="metric">
        <text class="metric-label">减重目标</text>
        <text class="metric-value">{{ startWeight }}-{{ targetWeight }}{{ unit }}</text>
      </view>
      <view class="metric">
        <text class="metric-label">每周减重</text>
        <text class="metric-value">{{ weeklyLoss }}{{ unit }}</text>
      </view>
    </view>
    <view class="weekly-highlight-row">
      <image class="weekly-boy" src="/static/plan/weekly-boy.png" mode="aspectFill" />
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
  gap: 12rpx;
}

.metric {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 10rpx;
  padding: 22rpx 12rpx;
  background: #ffffff;
  border-radius: 24rpx;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.04);
}

.metric-label {
  font-size: 22rpx;
  color: #888888;
}

.metric-value {
  font-size: 30rpx;
  font-weight: 700;
  color: #1a1a1a;
  word-break: break-all;
}

.weekly-highlight-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 20rpx;
}

.weekly-boy {
  width: 120rpx;
  height: 120rpx;
  border-radius: 24rpx;
  flex-shrink: 0;
  background: #eef3ee;
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
  font-size: 36rpx;
  font-weight: 700;
  color: #2e7d32;
}
</style>
