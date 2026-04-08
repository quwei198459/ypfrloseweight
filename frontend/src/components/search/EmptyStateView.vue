<template>
  <view class="empty-state">
    <view class="empty-illustration" />
    <text class="empty-text">{{ text }}</text>
  </view>
</template>

<script setup lang="ts">
withDefaults(
  defineProps<{
    text?: string
  }>(),
  {
    text: '试试搜索食物名称',
  },
)
</script>

<style lang="scss" scoped>
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80rpx 32rpx 40rpx;
  box-sizing: border-box;
}

.empty-illustration {
  width: 200rpx;
  height: 200rpx;
  border-radius: 24rpx;
  background: linear-gradient(160deg, #e8f4dc 0%, #d5e7b1 100%);
  border: 2rpx solid #c5d9a8;
}

.empty-text {
  margin-top: 24rpx;
  font-size: 28rpx;
  color: #8a8a8a;
  text-align: center;
}
</style>
