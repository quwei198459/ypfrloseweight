<template>
  <view class="hm">
    <view class="hm__badge">
      <view class="hm__badge-half hm__badge-half--used" />
      <view class="hm__badge-half hm__badge-half--rest" />
      <text class="hm__badge-text">{{ badgePercentLabel }}</text>
    </view>
    <view class="hm__strip">
      <text class="hm__strip-emoji">🐼</text>
      <text class="hm__strip-text">{{ stripText }}</text>
    </view>
  </view>
</template>

<script setup lang="ts">
defineProps<{
  badgePercentLabel: string
  stripText: string
}>()
</script>

<style lang="scss" scoped>
.hm {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 16rpx;
  width: 100%;
  box-sizing: border-box;
}

.hm__badge {
  position: relative;
  width: 88rpx;
  height: 88rpx;
  border-radius: 44rpx;
  background: #ffffff;
  border: 5rpx solid #7cb342;
  box-sizing: border-box;
  overflow: hidden;
  flex-shrink: 0;
}

.hm__badge-half {
  position: absolute;
  top: 0;
  width: 50%;
  height: 100%;
}

.hm__badge-half--used {
  left: 0;
  background: #7cb342;
}

.hm__badge-half--rest {
  right: 0;
  background: #dcedc8;
}

.hm__badge-text {
  position: relative;
  z-index: 2;
  width: 100%;
  height: 100%;
  font-size: 18rpx;
  font-weight: 700;
  color: #1b5e20;
  line-height: 88rpx;
  text-align: center;
}

.hm__strip {
  flex: 1;
  min-width: 0;
  min-height: 72rpx;
  padding: 12rpx 24rpx;
  border-radius: 36rpx;
  background: #e3f2e0;
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 12rpx;
  box-sizing: border-box;
}

.hm__strip-emoji {
  font-size: 28rpx;
  line-height: 1;
  flex-shrink: 0;
}

.hm__strip-text {
  flex: 1;
  font-size: 22rpx;
  font-weight: 500;
  color: #333333;
  line-height: 1.45;
}
</style>
