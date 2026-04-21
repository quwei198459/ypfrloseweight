<template>
  <view v-if="visible && food" class="food-record-popup">
    <view class="popup-mask" @click="onMask" />
    <view class="popup-panel" @click.stop>
      <view class="popup-top-row">
        <view class="popup-panda-peek">
          <text class="panda-emoji">🐼</text>
        </view>
        <view class="popup-close-button" @click="close">
          <text class="close-x">×</text>
        </view>
      </view>

      <view class="popup-food-header">
        <view class="food-image">
          <text class="food-emoji">🍽</text>
        </view>
        <view class="food-header-text">
          <text class="food-name">{{ food.name }}</text>
          <text class="food-calorie-summary">{{ calorieSummaryLine }}</text>
          <view v-if="food.giLevel" class="gi-tag" :class="'gi-' + food.giLevel">
            <text class="gi-tag-text">{{ giLabel }}</text>
          </view>
        </view>
      </view>

      <NutritionSummaryChart :center-calorie="chartCenterCal" :rows="chartRows" />

      <view class="quantity-section">
        <text class="edible-part-text">可食部分：1800g</text>
        <view class="quantity-display-row">
          <view class="quantity-row-spacer" />
          <view class="quantity-value-block">
            <text class="quantity-value">{{ displayQuantity }}</text>
            <view class="quantity-underline" />
            <view class="quantity-unit-row">
              <text class="quantity-unit">克</text>
              <text class="quantity-chevron">⌄</text>
            </view>
          </view>
          <view class="estimate-action">
            <text class="estimate-label">估重</text>
            <view class="estimate-icon">
              <text class="estimate-q">?</text>
            </view>
          </view>
        </view>
        <view class="keyboard-area">
          <NumberKeyboard @input="onKey" @delete="onDelete" @confirm="onConfirm" />
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { SearchFoodItem } from '@/types/searchFood'
import NutritionSummaryChart from './NutritionSummaryChart.vue'
import NumberKeyboard from './NumberKeyboard.vue'

const props = defineProps<{
  visible: boolean
  food: SearchFoodItem | null
  quantity: string
}>()

const emit = defineEmits<{
  (e: 'update:visible', v: boolean): void
  (e: 'update:quantity', v: string): void
  (e: 'confirm'): void
}>()

const giLabel = computed(() => {
  const lv = props.food?.giLevel
  const m: Record<string, string> = { low: '低Gi', medium: '中Gi', high: '高Gi' }
  return lv ? m[lv] || 'Gi' : 'Gi'
})

const calorieSummaryLine = computed(() => {
  if (!props.food) return ''
  return props.food.calorieSummary || `${props.food.calorie} ${props.food.unit}`
})

const chartCenterCal = computed(() => {
  if (props.food?.name === '桔子' && props.food.calorieSummary) return '864'
  return props.food?.calorie ?? '864'
})

const chartRows = computed((): { color: string; line: string }[] => {
  if (props.food?.name === '桔子') {
    return [
      { color: '#8bc34a', line: '碳水: 180.0g 87%' },
      { color: '#ffca28', line: '蛋白质: 18.0g 9%' },
      { color: '#ef5350', line: '脂肪: 9.0g 4%' },
    ]
  }
  return [
    { color: '#8bc34a', line: '碳水: —' },
    { color: '#ffca28', line: '蛋白质: —' },
    { color: '#ef5350', line: '脂肪: —' },
  ]
})

const displayQuantity = computed(() => (props.quantity.trim() === '' ? '0' : props.quantity))

const close = () => emit('update:visible', false)

const onMask = () => close()

const onKey = (key: string) => {
  const cur = props.quantity
  if (key === '.') {
    if (cur.includes('.')) return
    emit('update:quantity', cur === '' ? '0.' : cur + '.')
    return
  }
  if (key === '0' && cur === '0') return
  if (cur === '0' && key !== '.') {
    emit('update:quantity', key)
    return
  }
  emit('update:quantity', cur + key)
}

const onDelete = () => {
  const cur = props.quantity
  if (!cur.length) return
  emit('update:quantity', cur.slice(0, -1))
}

const onConfirm = () => {
  emit('confirm')
}
</script>

<style lang="scss" scoped>
.food-record-popup {
  position: fixed;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  z-index: 1000;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
}

.popup-mask {
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.45);
}

.popup-panel {
  position: relative;
  width: 100%;
  max-height: 90vh;
  background: #ffffff;
  border-radius: 24rpx 24rpx 0 0;
  padding: 16rpx 24rpx calc(16rpx + env(safe-area-inset-bottom));
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  z-index: 1;
}

.popup-top-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 8rpx;
}

.popup-panda-peek {
  width: 88rpx;
  height: 72rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.panda-emoji {
  font-size: 44rpx;
  color: #757575;
}

.popup-close-button {
  width: 64rpx;
  height: 64rpx;
  border-radius: 32rpx;
  background: #eeeeee;
  display: flex;
  align-items: center;
  justify-content: center;
}

.close-x {
  font-size: 40rpx;
  color: #757575;
  line-height: 1;
}

.popup-food-header {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 20rpx;
  margin-bottom: 8rpx;
}

.popup-food-header .food-image {
  width: 104rpx;
  height: 104rpx;
  border-radius: 20rpx;
  background: #fff8e1;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.food-emoji {
  font-size: 44rpx;
  color: #a1887f;
}

.food-header-text {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 8rpx;
}

.popup-food-header .food-name {
  font-size: 36rpx;
  font-weight: 600;
  color: #212121;
}

.food-calorie-summary {
  font-size: 24rpx;
  color: #7cb342;
}

.gi-tag {
  align-self: flex-start;
  padding: 8rpx 16rpx;
  border-radius: 12rpx;
  margin-top: 4rpx;
}

.gi-tag-text {
  font-size: 22rpx;
  font-weight: normal;
}

.gi-low {
  background: #e8f5e9;
}
.gi-low .gi-tag-text {
  color: #2e7d32;
}
.gi-medium {
  background: #fff3e0;
}
.gi-medium .gi-tag-text {
  color: #e65100;
}
.gi-high {
  background: #ffebee;
}
.gi-high .gi-tag-text {
  color: #c62828;
}

.quantity-section {
  display: flex;
  flex-direction: column;
  width: 100%;
  margin-top: 8rpx;
}

.edible-part-text {
  font-size: 22rpx;
  color: #ff9800;
  text-align: center;
  width: 100%;
  margin-bottom: 8rpx;
}

.quantity-display-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  gap: 16rpx;
  padding: 4rpx 0;
  margin-bottom: 12rpx;
}

.quantity-row-spacer {
  width: 64rpx;
  flex-shrink: 0;
}

.quantity-value-block {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8rpx;
}

.quantity-value {
  font-size: 64rpx;
  font-weight: 600;
  color: #8bc34a;
  line-height: 1.1;
}

.quantity-underline {
  width: 80rpx;
  height: 4rpx;
  background: #8bc34a;
  border-radius: 2rpx;
}

.quantity-unit-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 8rpx;
}

.quantity-unit {
  font-size: 26rpx;
  font-weight: 600;
  color: #33691e;
}

.quantity-chevron {
  font-size: 28rpx;
  color: #8bc34a;
  line-height: 1;
}

.estimate-action {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 8rpx;
  flex-shrink: 0;
}

.estimate-label {
  font-size: 22rpx;
  color: #8bc34a;
}

.estimate-icon {
  width: 32rpx;
  height: 32rpx;
  border-radius: 16rpx;
  border: 1rpx solid #8bc34a;
  display: flex;
  align-items: center;
  justify-content: center;
}

.estimate-q {
  font-size: 18rpx;
  font-weight: 600;
  color: #8bc34a;
}

.keyboard-area {
  width: 100%;
}
</style>
