<template>
  <view class="metric-card">
    <view class="metric-head">
      <text class="metric-title">{{ title }}</text>
      <view class="arrow-wrap">
        <text class="metric-arrow">›</text>
      </view>
    </view>
    <text class="metric-value">{{ value }}</text>
    <text class="metric-desc">{{ desc }}</text>
  </view>
</template>

<script setup lang="ts">
defineProps<{
  title: string
  value: string
  desc: string
}>()
</script>

<style lang="scss" scoped>
@use './user-variables.scss' as *;

.metric-card {
  width: 100%;
  background: $user-card-bg;
  border-radius: 32rpx;
  box-shadow: $user-card-shadow;
  padding: 22rpx 24rpx 26rpx;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  justify-content: flex-start;
  gap: 14rpx;
  min-width: 0;
  min-height: 212rpx;
}

.metric-head {
  width: 100%;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  min-height: 52rpx;
}

.metric-title {
  flex: 1;
  min-width: 0;
  font-size: 24rpx;
  color: $user-text-hint;
  line-height: 1.3;
}

.arrow-wrap {
  width: 52rpx;
  height: 52rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.metric-arrow {
  font-size: 48rpx;
  color: #bfbfbf;
  line-height: 1;
}

.metric-value {
  display: block;
  width: 100%;
  font-size: 42rpx;
  font-weight: 600;
  color: #c5d99b;
  line-height: 1.2;
  margin-top: 2rpx;
}

.metric-desc {
  display: block;
  width: 100%;
  font-size: 22rpx;
  color: $user-text-hint;
  line-height: 1.4;
  margin-top: auto;
  padding-top: 4rpx;
}
</style>
