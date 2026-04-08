<template>
  <view class="ras-mask" @click="emit('close')">
    <view class="ras-sheet" @click.stop>
      <view class="ras-handle" />

      <view class="ras-top">
        <view class="ras-progress-row">
          <view class="ras-track">
            <view class="ras-fill" :style="{ width: budgetFillPercent + '%' }" />
          </view>
          <text class="ras-kcal-pair">{{ kcalPairText }}</text>
        </view>
        <view class="ras-mini-row">
          <view class="ras-thumb" />
          <view class="ras-add-btn" @click="emit('add')">
            <text class="ras-add-text">添加到{{ mealShortLabel }}</text>
          </view>
        </view>
      </view>

      <view class="ras-card">
        <view class="ras-card-top">
          <view class="ras-big-thumb" />
          <view class="ras-card-col">
            <view class="ras-gi">
              <text class="ras-gi-t">{{ giLabel }}</text>
            </view>
            <text class="ras-food-name">{{ foodName }}</text>
            <text class="ras-food-kcal">{{ displayedCalories }} 千卡</text>
          </view>
          <view class="ras-check">
            <text class="ras-check-dot">✓</text>
          </view>
        </view>
        <view class="ras-slider-block">
          <text class="ras-slider-hint">食用比例</text>
          <slider
            class="ras-slider"
            :value="ratioPercent"
            min="0"
            max="100"
            step="1"
            activeColor="#2e7d32"
            backgroundColor="#c8e6c9"
            block-size="20"
            @changing="onSlider"
            @change="onSlider"
          />
          <text class="ras-slider-val">{{ ratioPercent }}%</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  foodName: string
  giLabel: string
  displayedCalories: number
  kcalPairText: string
  mealShortLabel: string
  ratioPercent: number
  intakeToday: number
  dailyBudget: number
}>()

const emit = defineEmits<{
  (e: 'update:ratioPercent', v: number): void
  (e: 'close'): void
  (e: 'add'): void
}>()

const budgetFillPercent = computed(() => {
  const b = props.dailyBudget
  if (!b || b <= 0) return 0
  const p = (props.intakeToday / b) * 100
  return Math.min(100, Math.round(p))
})

function onSlider(e: { detail: { value: number } }) {
  emit('update:ratioPercent', Number(e.detail.value))
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
  gap: 32rpx;
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
  flex-direction: column;
  gap: 24rpx;
}

.ras-progress-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  gap: 20rpx;
}

.ras-track {
  flex: 1;
  height: 16rpx;
  border-radius: 8rpx;
  background: #e0e0e0;
  overflow: hidden;
}

.ras-fill {
  height: 100%;
  border-radius: 8rpx;
  background: #2e7d32;
}

.ras-kcal-pair {
  font-size: 26rpx;
  font-weight: 600;
  color: #333333;
  flex-shrink: 0;
}

.ras-mini-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  padding: 8rpx 0;
}

.ras-thumb {
  width: 96rpx;
  height: 96rpx;
  border-radius: 20rpx;
  background: #d8d8d8;
  border: 1rpx solid #cccccc;
  flex-shrink: 0;
}

.ras-add-btn {
  padding: 20rpx 36rpx;
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
  gap: 24rpx;
}

.ras-big-thumb {
  width: 144rpx;
  height: 144rpx;
  border-radius: 24rpx;
  background: #d8d8d8;
  flex-shrink: 0;
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
  font-size: 28rpx;
  font-weight: 600;
  color: #222222;
}

.ras-food-kcal {
  font-size: 32rpx;
  font-weight: 700;
  color: #bf360c;
}

.ras-check {
  width: 56rpx;
  height: 56rpx;
  border-radius: 28rpx;
  background: #8bc34a;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.ras-check-dot {
  font-size: 22rpx;
  color: #ffffff;
  font-weight: 700;
}

.ras-slider-block {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
}

.ras-slider-hint {
  font-size: 24rpx;
  color: #666666;
}

.ras-slider {
  width: 100%;
}

.ras-slider-val {
  font-size: 24rpx;
  color: #333333;
  text-align: right;
}
</style>
