<template>
  <view class="plan-strategy-card">
    <view class="plan-strategy-metrics-row">
      <view class="cell calorie-target">
        <text class="cell-label">{{ calorieLabel }}</text>
        <text class="cell-value accent">{{ calorieValue }}</text>
      </view>
      <view class="cell exercise-frequency">
        <text class="cell-label">{{ exerciseLabel }}</text>
        <text class="cell-value">{{ exerciseValue }}</text>
      </view>
    </view>
    <view class="plan-strategy-diet-row">
      <view class="cell bordered diet-pattern">
        <text class="cell-label">{{ dietPatternLabel }}</text>
        <text class="cell-value accent">{{ dietPatternValue }}</text>
      </view>
      <view class="cell bordered diet-recommendation">
        <text class="cell-label">{{ dietRecommendLabel }}</text>
        <text class="cell-value small">{{ dietRecommendValue }}</text>
      </view>
    </view>
  </view>
</template>

<script setup>
defineProps({
  calorieLabel: { type: String, default: '热量摄入' },
  calorieValue: { type: String, required: true },
  exerciseLabel: { type: String, default: '运动频率' },
  exerciseValue: { type: String, required: true },
  dietPatternLabel: { type: String, default: '饮食节奏' },
  dietPatternValue: { type: String, required: true },
  dietRecommendLabel: { type: String, default: '饮食推荐' },
  dietRecommendValue: { type: String, required: true },
})
</script>

<style scoped>
.plan-strategy-card {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
  padding: 32rpx;
  background: #ffffff;
  border-radius: 32rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.06);
}

.plan-strategy-metrics-row,
.plan-strategy-diet-row {
  display: flex;
  flex-direction: row;
  gap: 20rpx;
}

.cell {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 12rpx;
  padding: 24rpx 20rpx;
  border-radius: 24rpx;
  background: #f7faf6;
}

.cell.bordered {
  background: #ffffff;
  border: 1rpx solid #e0e8de;
}

.cell-label {
  font-size: 22rpx;
  color: #888888;
}

.cell-value {
  font-size: 26rpx;
  font-weight: 600;
  color: #1a1a1a;
}

.cell-value.accent {
  color: #2e7d32;
}

.cell-value.small {
  font-size: 26rpx;
  line-height: 1.35;
}
</style>
