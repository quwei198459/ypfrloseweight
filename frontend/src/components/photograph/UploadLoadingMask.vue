<template>
  <view class="loading-mask" @touchmove.stop.prevent>
    <view class="loading-mask__panel">
      <view class="loading-mask__spinner" />
      <text class="loading-mask__text">上传中</text>
    </view>
  </view>
</template>

<script setup lang="ts"></script>

<style lang="scss" scoped>
.loading-mask {
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  z-index: 10;
  display: flex;
  align-items: center;
  justify-content: center;
  pointer-events: auto;
}

.loading-mask__panel {
  width: 360rpx;
  min-height: 200rpx;
  padding: 36rpx 28rpx;
  box-sizing: border-box;
  border-radius: 20rpx;
  background: rgba(75, 75, 75, 0.78);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 20rpx;
}

.loading-mask__spinner {
  width: 56rpx;
  height: 56rpx;
  border: 5rpx solid rgba(255, 255, 255, 0.25);
  border-top-color: #ffffff;
  border-radius: 50%;
  animation: upload-spin 0.75s linear infinite;
}

.loading-mask__text {
  font-size: 28rpx;
  font-weight: 500;
  color: #ffffff;
}

@keyframes upload-spin {
  to {
    transform: rotate(360deg);
  }
}
</style>
