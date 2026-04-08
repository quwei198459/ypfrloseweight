<template>
  <view class="selected-bar" v-if="visible">
    <view class="left">
      <view class="panda-icon" />
      <view class="text-col">
        <text class="meal-title">{{ mealTitle }}</text>
        <text class="summary-text">{{ summaryText }}</text>
        <text class="calories">{{ caloriesText }}</text>
      </view>
    </view>
    <button class="confirm-btn" @click="emit('confirm')">
      完成
    </button>
  </view>
</template>

<script setup lang="ts">
const props = defineProps<{
  visible: boolean
  mealTitle: string
  summaryText: string
  caloriesText: string
}>()

const emit = defineEmits<{
  (e: 'confirm'): void
}>()
</script>

<style scoped lang="scss">
.selected-bar {
  position: fixed;
  left: 16px;
  right: 16px;
  bottom: 12px;
  height: 72px;
  border-radius: 24px;
  background: #e7f2d1;
  padding: 12px 20px;
  box-sizing: border-box;
  display: flex;
  align-items: center;
  justify-content: space-between;
  z-index: 20;
}

.left {
  display: flex;
  align-items: center;
  gap: 8px;
}

.panda-icon {
  width: 40px;
  height: 40px;
  border-radius: 20px;
  background: #ffffff;
}

.text-col {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.meal-title {
  font-size: 13px;
  font-weight: 600;
  color: #222222;
}

.summary-text {
  font-size: 11px;
  color: #666666;
}

.calories {
  font-size: 13px;
  font-weight: 600;
  color: #4b7a2d;
}

.confirm-btn {
  width: 96px;
  height: 40px;
  border-radius: 20px;
  background: #bfd98a;
  border: 0;
  font-size: 14px;
  font-weight: 600;
  color: #4b5b2d;
}
</style>

