<template>
  <view class="ras-mask" @click="emit('close')">
    <view class="ras-sheet" @click.stop>
      <view class="ras-handle" />

      <view class="ras-top">
        <text class="ras-summary">{{ summaryText }}</text>
        <view class="ras-add-btn" @click="emit('add')">
          <text class="ras-add-text">添加到{{ mealShortLabel }}</text>
        </view>
      </view>

      <scroll-view scroll-y class="ras-list">
        <view class="ras-list__inner">
          <view v-for="food in foods" :key="food.lineId" class="ras-card">
            <view class="ras-card-top">
              <view class="ras-card-col">
                <view v-if="food.giLabel && food.giLabel.trim()" class="ras-gi">
                  <text class="ras-gi-t">{{ food.giLabel }}</text>
                </view>
                <text class="ras-food-name">{{ food.foodName }}</text>
                <text class="ras-food-kcal">{{ getDisplayedQuantityLabel(food) }} · {{ getDisplayedCalories(food.lineId) }} 千卡</text>
              </view>
            </view>
            <view class="ras-slider-block">
              <view class="ras-slider-head">
                <text class="ras-slider-hint">食用比例</text>
                <text class="ras-slider-val">{{ getRatio(food.lineId) }}%</text>
              </view>
              <view class="ras-slider-pad">
                <slider
                  class="ras-slider"
                  :value="getRatio(food.lineId)"
                  min="0"
                  max="100"
                  step="1"
                  activeColor="#2e7d32"
                  backgroundColor="#c8e6c9"
                  block-size="26"
                  block-color="#d5e7b1"
                  @changing="onSlider(food.lineId, $event)"
                  @change="onSlider(food.lineId, $event)"
                />
              </view>
            </view>
          </view>

          <view v-if="foods.length === 0" class="ras-empty">
            <text class="ras-empty__text">暂无可调节食物</text>
          </view>
        </view>
      </scroll-view>
    </view>
  </view>
</template>

<script setup lang="ts">
import type { PhotographMockFood } from '@/types/photograph'

const props = defineProps<{
  foods: PhotographMockFood[]
  ratioPercentMap: Record<string, number>
  summaryText: string
  mealShortLabel: string
  getDisplayedCalories: (lineId: string) => number
}>()

const emit = defineEmits<{
  (e: 'update-food-ratio', lineId: string, v: number): void
  (e: 'close'): void
  (e: 'add'): void
}>()

function getRatio(lineId: string) {
  const v = props.ratioPercentMap[lineId]
  if (!Number.isFinite(v)) return 100
  return Math.min(100, Math.max(0, Math.round(v)))
}

function getDisplayedQuantityLabel(food: PhotographMockFood) {
  const base = Number(food.quantity ?? 100)
  const safeBase = Number.isFinite(base) && base > 0 ? base : 100
  const actual = Math.round(safeBase * getRatio(food.lineId)) / 100
  const rounded = Math.round(actual * 10) / 10
  const text = Number.isInteger(rounded) ? String(rounded) : String(rounded).replace(/\.0$/, '')
  return `${text} ${food.quantityUnit || 'g/ml'}`
}

function onSlider(lineId: string, e: { detail: { value: number } }) {
  emit('update-food-ratio', lineId, Number(e.detail.value))
}
</script>

<style lang="scss" scoped>
.ras-mask {
  position: fixed;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  z-index: 180;
  background: rgba(0, 0, 0, 0.25);
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
  box-sizing: border-box;
}

.ras-sheet {
  background: #ffffff;
  border-radius: 56rpx 56rpx 0 0;
  border: 1rpx solid #e8e8e8;
  padding: 16rpx 40rpx calc(32rpx + env(safe-area-inset-bottom));
  box-sizing: border-box;
  max-height: 88vh;
  display: flex;
  flex-direction: column;
  gap: 28rpx;
}

.ras-handle {
  width: 72rpx;
  height: 8rpx;
  border-radius: 4rpx;
  background: #e0e0e0;
  align-self: center;
  margin-bottom: 8rpx;
}

.ras-top {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  gap: 20rpx;
  flex-shrink: 0;
}

.ras-summary {
  flex: 1;
  min-width: 0;
  font-size: 30rpx;
  font-weight: 700;
  color: #222222;
  line-height: 1.4;
}

.ras-add-btn {
  padding: 20rpx 34rpx;
  border-radius: 40rpx;
  background: #d5e7b1;
  border: 2rpx solid #9ebc86;
  flex-shrink: 0;
}

.ras-add-text {
  font-size: 26rpx;
  font-weight: 600;
  color: #2d3d22;
}

.ras-list {
  flex: 1;
  min-height: 0;
  max-height: 64vh;
}

.ras-list__inner {
  display: flex;
  flex-direction: column;
  gap: 24rpx;
  padding-bottom: 8rpx;
}

.ras-card {
  background: #f7fbf7;
  border-radius: 36rpx;
  border: 1rpx solid #dce8cf;
  padding: 28rpx;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 24rpx;
}

.ras-card-top {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
}

.ras-card-col {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.ras-gi {
  align-self: flex-start;
  padding: 8rpx 16rpx;
  border-radius: 12rpx;
  background: #dceedd;
}

.ras-gi-t {
  font-size: 22rpx;
  font-weight: 600;
  color: #2d5a27;
}

.ras-food-name {
  max-width: 100%;
  font-size: 28rpx;
  font-weight: 600;
  color: #222222;
  line-height: 1.35;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.ras-food-kcal {
  font-size: 32rpx;
  font-weight: 700;
  color: #bf360c;
}

.ras-slider-block {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
}

.ras-slider-head {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
}

.ras-slider-hint {
  font-size: 24rpx;
  color: #666666;
}

.ras-slider-pad {
  padding: 0 28rpx;
  box-sizing: border-box;
}

.ras-slider {
  width: 100%;
}

.ras-slider-val {
  font-size: 24rpx;
  color: #333333;
  text-align: right;
}

.ras-empty {
  min-height: 160rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.ras-empty__text {
  font-size: 26rpx;
  color: #888888;
}
</style>
