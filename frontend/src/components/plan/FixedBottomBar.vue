<template>
  <view class="fixed-bottom-bar">
    <text class="fixed-bottom-slogan">{{ slogan }}</text>
    <view class="start-plan-button" @click="onPrimary">
      <text class="start-plan-button-label">{{ buttonText }}</text>
      <view v-if="showVip" class="start-plan-vip-badge">
        <text class="vip-text">VIP</text>
      </view>
    </view>
  </view>
</template>

<script setup>
const emit = defineEmits(['primary'])

defineProps({
  slogan: { type: String, required: true },
  buttonText: { type: String, default: '开始使用专属计划' },
  showVip: { type: Boolean, default: true },
})

function onPrimary() {
  emit('primary')
}
</script>

<style scoped>
.fixed-bottom-bar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 100;
  display: flex;
  flex-direction: column;
  align-items: stretch;
  gap: 20rpx;
  padding: 24rpx 32rpx;
  padding-bottom: calc(24rpx + env(safe-area-inset-bottom));
  background: #f0f7ed;
  box-sizing: border-box;
}

.fixed-bottom-slogan {
  text-align: center;
  font-size: 24rpx;
  color: #666666;
  line-height: 1.4;
}

.start-plan-button {
  position: relative;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  min-height: 100rpx;
  padding: 0 32rpx 0 40rpx;
  background: #8bc34a;
  border-radius: 50rpx;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.08);
  box-sizing: border-box;
}

.start-plan-button-label {
  flex: 1;
  text-align: center;
  font-size: 32rpx;
  font-weight: 600;
  color: #1b5e20;
}

.start-plan-vip-badge {
  width: 60rpx;
  height: 60rpx;
  border-radius: 30rpx;
  background: #ffd54f;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.vip-text {
  font-size: 16rpx;
  font-weight: 700;
  color: #5d4037;
}
</style>
