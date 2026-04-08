<template>
  <view class="banner">
    <view class="banner-panda" aria-hidden="true">
      <text class="banner-panda__emoji">🐼</text>
    </view>
    <text class="banner-txt">量身定制方案，助力轻松减脂</text>
    <view class="banner-btn" @click="$emit('action')">
      <text class="banner-btn__txt">前往查看</text>
    </view>
  </view>
</template>

<script setup lang="ts">
defineEmits<{
  (e: 'action'): void
}>()
</script>

<style lang="scss" scoped>
.banner {
  width: 100%;
  min-height: 100rpx;
  background: #fff3c4;
  border-radius: 24rpx;
  padding: 20rpx 24rpx;
  box-sizing: border-box;
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 14rpx;
}

.banner-panda {
  width: 64rpx;
  height: 64rpx;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.72);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.banner-panda__emoji {
  font-size: 40rpx;
  line-height: 1;
}

.banner-txt {
  flex: 1;
  min-width: 0;
  font-size: 26rpx;
  color: #4a3d2a;
  line-height: 1.38;
  font-weight: 500;
}

.banner-btn {
  flex-shrink: 0;
  padding: 12rpx 26rpx;
  background: #fff;
  border-radius: 28rpx;
  align-self: center;
}

.banner-btn__txt {
  font-size: 24rpx;
  font-weight: 600;
  color: #1a1a1a;
  line-height: 1.2;
}
</style>
