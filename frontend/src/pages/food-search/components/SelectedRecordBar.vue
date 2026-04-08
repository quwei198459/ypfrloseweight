<template>
  <view v-if="visible" class="bar" @click="emit('open')">
    <view class="left">
      <image class="panda" src="/static/category/category-lunch-active.png" mode="aspectFit" />
      <view class="text-col">
        <text class="meal">{{ mealLabel }}</text>
        <view class="summary-row">
          <text class="summary">共{{ count }}条记录，总计</text>
          <text class="kcal">{{ totalKcal }}千卡</text>
        </view>
      </view>
    </view>
    <button class="done" @click.stop="emit('complete')">完成</button>
  </view>
</template>

<script setup lang="ts">
defineProps<{
  visible: boolean
  mealLabel: string
  count: number
  totalKcal: number
}>()

const emit = defineEmits<{
  (e: 'open'): void
  (e: 'complete'): void
}>()
</script>

<style scoped lang="scss">
.bar {
  position: fixed;
  left: 16px;
  right: 16px;
  bottom: 12px;
  height: 76px;
  padding: 10px 12px;
  border-radius: 18px;
  background: #f4f8e8;
  border: 1px solid #d7e3be;
  display: flex;
  align-items: center;
  justify-content: space-between;
  z-index: 30;
}
.left { display: flex; align-items: center; gap: 8px; }
.panda { width: 38px; height: 38px; }
.text-col { display: flex; flex-direction: column; gap: 2px; }
.meal { font-size: 13px; font-weight: 600; color: #212121; }
.summary-row { display: flex; align-items: baseline; gap: 3px; }
.summary { font-size: 11px; color: #6f6f6f; }
.kcal { font-size: 13px; font-weight: 700; color: #8eaf57; }
.done {
  width: 94px;
  height: 40px;
  border-radius: 20px;
  background: #bfd98a;
  color: #49592d;
  font-size: 14px;
  font-weight: 600;
  border: 0;
  line-height: 40px;
  padding: 0;
}
</style>

