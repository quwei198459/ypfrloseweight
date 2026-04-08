<template>
  <view class="info-row" @click="$emit('click')">
    <text class="info-row__label">{{ label }}</text>
    <view class="info-row__right">
      <text class="info-row__value">{{ value }}</text>
      <text class="chevron">›</text>
    </view>
  </view>
</template>

<script setup lang="ts">
defineProps<{
  label: string
  value: string
}>()
defineEmits<{
  (e: 'click'): void
}>()
</script>

<style lang="scss" scoped>
@use './user-variables.scss' as *;

.info-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  min-height: 96rpx;
  padding: 0;
  box-sizing: border-box;
}

.info-row__label {
  font-size: $user-label-size;
  color: $user-text-primary;
  font-weight: normal;
}

.info-row__right {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 12rpx;
}

.info-row__value {
  font-size: $user-value-size;
  color: $user-text-secondary;
  font-weight: normal;
}

.chevron {
  font-size: 32rpx;
  color: $user-chevron;
  line-height: 1;
}
</style>
