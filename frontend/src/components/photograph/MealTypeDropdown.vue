<template>
  <view class="md-panel" @click.stop>
    <view
      v-for="opt in options"
      :key="opt.key"
      class="md-row"
      :class="{ 'md-row--active': opt.key === modelValue }"
      @click="emit('select', opt.key)"
    >
      <text class="md-row__text">{{ opt.label }}</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import type { MealTypeKey } from '@/types/photograph'
import { MEAL_OPTIONS } from '@/mocks/photographFlow.mock'

defineProps<{
  modelValue: MealTypeKey
}>()

const emit = defineEmits<{
  (e: 'select', key: MealTypeKey): void
}>()

const options = MEAL_OPTIONS
</script>

<style lang="scss" scoped>
.md-panel {
  width: 296rpx;
  max-width: 86vw;
  background: #ffffff;
  border-radius: 16rpx;
  border: 1rpx solid #e8e8e8;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.06);
  overflow: hidden;
  box-sizing: border-box;
}

.md-row {
  padding: 16rpx 32rpx;
  box-sizing: border-box;
}

.md-row--active {
  background: #e8f5e9;
}

.md-row__text {
  font-size: 28rpx;
  color: #222222;
  line-height: 1.35;
}
</style>
