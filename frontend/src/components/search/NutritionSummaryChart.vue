<template>
  <view class="nutrition-summary-section">
    <view class="calorie-chart">
      <view class="ring-wrap">
        <view class="ring" />
        <view class="ring-center">
          <text class="ring-cal">{{ centerCalorie }}</text>
          <text class="ring-unit">Kcal</text>
        </view>
      </view>
    </view>
    <view class="nutrition-item-list">
      <view v-for="(row, i) in rows" :key="i" class="nutrition-item-row">
        <view class="swatch" :style="{ background: row.color }" />
        <text class="item-line">{{ row.line }}</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
export interface NutritionTextRow {
  color: string
  line: string
}

withDefaults(
  defineProps<{
    centerCalorie?: string | number
    rows?: NutritionTextRow[]
  }>(),
  {
    centerCalorie: '864',
    rows: () => [
      { color: '#8bc34a', line: '碳水: 180.0g 87%' },
      { color: '#ffca28', line: '蛋白质: 18.0g 9%' },
      { color: '#ef5350', line: '脂肪: 9.0g 4%' },
    ],
  },
)
</script>

<style lang="scss" scoped>
.nutrition-summary-section {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 28rpx;
  padding: 16rpx 0;
  width: 100%;
  box-sizing: border-box;
}

.calorie-chart {
  flex-shrink: 0;
}

.ring-wrap {
  position: relative;
  width: 216rpx;
  height: 216rpx;
}

.ring {
  position: absolute;
  inset: 0;
  border-radius: 50%;
  background: #f1f8e9;
  border: 20rpx solid #a5d6a7;
  box-sizing: border-box;
}

.ring-center {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.ring-cal {
  font-size: 40rpx;
  font-weight: 700;
  color: #33691e;
}

.ring-unit {
  font-size: 22rpx;
  color: #689f38;
  margin-top: 4rpx;
}

.nutrition-item-list {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.nutrition-item-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 16rpx;
}

.swatch {
  width: 20rpx;
  height: 20rpx;
  border-radius: 4rpx;
  flex-shrink: 0;
}

.item-line {
  flex: 1;
  min-width: 0;
  font-size: 24rpx;
  font-weight: normal;
  color: #424242;
}
</style>
