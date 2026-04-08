<template>
  <view class="member-notice-bar" role="text" aria-live="polite">
    <view class="member-notice-bar__icon-wrap">
      <text class="member-notice-bar__icon">🔊</text>
    </view>
    <text class="member-notice-bar__text">{{ text }}</text>
  </view>
</template>

<script setup>
defineProps({
  text: {
    type: String,
    default: '旋***成为了年费会员',
  },
})
</script>

<style lang="scss" scoped>
.member-notice-bar {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 16rpx;
  width: 100%;
  padding: 24rpx 28rpx;
  background: #f0f0f0;
  border-radius: 48rpx;
  box-sizing: border-box;
}

.member-notice-bar__icon-wrap {
  flex-shrink: 0;
  width: 36rpx;
  height: 36rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.member-notice-bar__icon {
  font-size: 28rpx;
  line-height: 1;
}

.member-notice-bar__text {
  flex: 1;
  min-width: 0;
  font-size: 24rpx;
  color: #666666;
  line-height: 1.5;
}
</style>
