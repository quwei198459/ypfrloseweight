<template>
  <view class="failed-action-row">
    <view class="failed-action-row__btn failed-action-row__btn--outline" @click="emit('exit')">
      <text class="failed-action-row__btn-text failed-action-row__btn-text--outline">退出拍照</text>
    </view>
    <view class="failed-action-row__btn failed-action-row__btn--solid" @click="emit('continue')">
      <text class="failed-action-row__btn-text failed-action-row__btn-text--solid">继续拍照</text>
    </view>
  </view>
</template>

<script setup lang="ts">
const emit = defineEmits<{
  (e: 'exit'): void
  (e: 'continue'): void
}>()
</script>

<style lang="scss" scoped>
.failed-action-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  gap: 24rpx;
  width: 100%;
  margin-top: 36rpx;
  padding: 0 8rpx 8rpx;
  box-sizing: border-box;
}

.failed-action-row__btn {
  flex: 1;
  height: 96rpx;
  border-radius: 48rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
}

.failed-action-row__btn--outline {
  background: #ffffff;
  border: 3rpx solid #8fa67a;
}

.failed-action-row__btn--solid {
  background: #d5e7b1;
  border: 2rpx solid #9ebc86;
}

.failed-action-row__btn-text {
  font-size: 30rpx;
  font-weight: 600;
}

.failed-action-row__btn-text--outline {
  color: #4b5b2d;
}

.failed-action-row__btn-text--solid {
  color: #2d3d22;
}
</style>
