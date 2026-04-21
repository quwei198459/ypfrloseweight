<template>
  <view class="stats-card">
    <view class="stats-col">
      <text class="stats-num">{{ recordCount }}</text>
      <text class="stats-lbl">记录饮食（次）</text>
    </view>
    <view class="stats-col">
      <text class="stats-num">{{ healthyDays }}</text>
      <text class="stats-lbl">健康饮食（天）</text>
    </view>
  </view>
</template>

<script setup lang="ts">
withDefaults(
  defineProps<{
    recordCount?: string | number
    healthyDays?: string | number
  }>(),
  {
    recordCount: 0,
    healthyDays: 0,
  }
)
</script>

<style lang="scss" scoped>
@use './user-variables.scss' as *;

.stats-card {
  width: 100%;
  background: $user-card-bg;
  border-radius: 32rpx;
  box-shadow: $user-card-shadow;
  padding: 32rpx 24rpx 36rpx;
  box-sizing: border-box;
  display: flex;
  flex-direction: row;
  align-items: stretch;
  justify-content: center;
  gap: 0;
  min-height: 168rpx;
}

.stats-col {
  flex: 1;
  width: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 10rpx;
  padding: 0 12rpx;
  box-sizing: border-box;
}

.stats-num {
  font-size: 40rpx;
  font-weight: 600;
  color: $user-text-primary;
  line-height: 1.15;
}

.stats-lbl {
  font-size: 22rpx;
  color: $user-text-hint;
  line-height: 1.35;
  text-align: center;
  padding: 0 4rpx;
}
</style>
