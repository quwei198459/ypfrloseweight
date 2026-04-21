<template>
  <view class="member-notice-bar" role="text" aria-live="polite">
    <view class="member-notice-bar__icon-wrap">
      <text class="member-notice-bar__icon">🔊</text>
    </view>
    <swiper
      class="member-notice-bar__swiper"
      vertical
      circular
      autoplay
      :interval="2600"
      :duration="400"
    >
      <swiper-item v-for="(line, i) in lines" :key="i" class="member-notice-bar__item">
        <text class="member-notice-bar__text">{{ line }}</text>
      </swiper-item>
    </swiper>
  </view>
</template>

<script setup lang="ts">
defineProps({
  lines: {
    type: Array,
    required: true,
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
  padding: 20rpx 28rpx;
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

.member-notice-bar__swiper {
  flex: 1;
  min-width: 0;
  height: 40rpx;
}

.member-notice-bar__item {
  display: flex;
  flex-direction: row;
  align-items: center;
}

.member-notice-bar__text {
  font-size: 24rpx;
  color: #666666;
  line-height: 1.4;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  width: 100%;
}
</style>
