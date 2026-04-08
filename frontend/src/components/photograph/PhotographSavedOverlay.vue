<template>
  <view class="pso">
    <view class="pso__circle">
      <text class="pso__tick">✓</text>
    </view>
    <text class="pso__title">已写入饮食记录</text>
    <text class="pso__sub">正在跳转每日饮食记录…</text>
  </view>
</template>

<script setup lang="ts"></script>

<style lang="scss" scoped>
.pso {
  position: fixed;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  z-index: 300;
  background: #f7f8f7;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 24rpx;
  padding: 48rpx;
  box-sizing: border-box;
}

.pso__circle {
  width: 120rpx;
  height: 120rpx;
  border-radius: 60rpx;
  background: #c8e6c9;
  display: flex;
  align-items: center;
  justify-content: center;
}

.pso__tick {
  font-size: 64rpx;
  font-weight: 700;
  color: #2e7d32;
  line-height: 1;
}

.pso__title {
  font-size: 36rpx;
  font-weight: 600;
  color: #1a1a1a;
}

.pso__sub {
  font-size: 26rpx;
  color: #666666;
}
</style>
