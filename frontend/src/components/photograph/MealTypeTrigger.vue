<template>
  <view class="mt" @click="emit('click')">
    <text class="mt__label">{{ mealLabel }}</text>
    <text class="mt__chevron">{{ open ? '⌃' : '⌄' }}</text>
  </view>
</template>

<script setup lang="ts">
defineProps<{
  mealLabel: string
  open?: boolean
}>()

const emit = defineEmits<{
  (e: 'click'): void
}>()
</script>

<style lang="scss" scoped>
.mt {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  gap: 8rpx;
  min-height: 64rpx;
}

.mt__label {
  font-size: 30rpx;
  font-weight: 600;
  color: #2d3d22;
  line-height: 1.2;
}

.mt__chevron {
  font-size: 24rpx;
  color: #666666;
  line-height: 1;
}
</style>
