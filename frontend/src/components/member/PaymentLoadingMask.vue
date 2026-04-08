<template>
  <view v-if="visible" class="payment-loading-mask" @click.stop>
    <view class="payment-loading-mask__panel">
      <view class="payment-loading-mask__spinner" />
      <text class="payment-loading-mask__label">{{ label }}</text>
    </view>
  </view>
</template>

<script setup>
defineProps({
  visible: {
    type: Boolean,
    default: false,
  },
  label: {
    type: String,
    default: '支付中',
  },
})
</script>

<style lang="scss" scoped>
.payment-loading-mask {
  position: fixed;
  left: 0;
  top: 0;
  right: 0;
  bottom: 0;
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.45);
  box-sizing: border-box;
}

.payment-loading-mask__panel {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 32rpx;
  min-width: 280rpx;
  padding: 48rpx 56rpx;
  background: #ffffff;
  border-radius: 24rpx;
  box-shadow: 0 8rpx 40rpx rgba(0, 0, 0, 0.12);
}

.payment-loading-mask__spinner {
  width: 64rpx;
  height: 64rpx;
  border: 6rpx solid #e0e0e0;
  border-top-color: #ff9800;
  border-radius: 50%;
  animation: pay-spin 0.8s linear infinite;
}

.payment-loading-mask__label {
  font-size: 28rpx;
  color: #333333;
  font-weight: 500;
}

@keyframes pay-spin {
  to {
    transform: rotate(360deg);
  }
}
</style>
