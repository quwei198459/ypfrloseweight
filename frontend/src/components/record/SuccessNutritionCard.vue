<template>
  <view class="nutrition-result-card">
    <text class="result-level-text">欠佳</text>
    <view class="nutrition-chart-row">
      <view class="calorie-chart">
        <view class="ring-wrap">
          <view class="ring" />
          <view class="ring-center">
            <text class="ring-cal">864</text>
            <text class="ring-unit">Kcal</text>
          </view>
        </view>
      </view>
      <view class="nutrition-item-list">
        <view class="nutrition-row">
          <view class="row-start">
            <view class="swatch swatch-carb" />
            <text class="ni-name">碳水</text>
          </view>
          <text class="ni-val">180g</text>
          <text class="ni-pct">82%</text>
        </view>
        <view class="nutrition-row">
          <view class="row-start">
            <view class="swatch swatch-protein" />
            <text class="ni-name">蛋白质</text>
          </view>
          <text class="ni-val">18g</text>
          <text class="ni-pct">8%</text>
        </view>
        <view class="nutrition-row">
          <view class="row-start">
            <view class="swatch swatch-fat" />
            <text class="ni-name">脂肪</text>
          </view>
          <text class="ni-val">9g</text>
          <text class="ni-pct">9%</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
</script>

<style lang="scss" scoped>
.nutrition-result-card {
  margin: 24rpx 0;
  padding: 32rpx;
  background: #ffffff;
  border-radius: 32rpx;
  border: 1rpx solid #eeeeee;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 24rpx;
}

.result-level-text {
  font-size: 56rpx;
  font-weight: 600;
  color: #a8c69f;
}

.nutrition-chart-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 24rpx;
}

.calorie-chart {
  flex-shrink: 0;
}

.ring-wrap {
  position: relative;
  width: 200rpx;
  height: 200rpx;
}

.ring {
  position: absolute;
  inset: 0;
  border-radius: 50%;
  background: #fff8e1;
  border: 16rpx solid #ffcc80;
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
  font-size: 36rpx;
  font-weight: 700;
  color: #e65100;
}

.ring-unit {
  font-size: 20rpx;
  color: #fb8c00;
  margin-top: 4rpx;
}

.nutrition-item-list {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.nutrition-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  gap: 12rpx;
  width: 100%;
}

.row-start {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 12rpx;
  flex: 1;
  min-width: 0;
}

.swatch {
  width: 20rpx;
  height: 20rpx;
  border-radius: 4rpx;
  flex-shrink: 0;
}

.swatch-carb {
  background: #a8d18d;
}
.swatch-protein {
  background: #ffc977;
}
.swatch-fat {
  background: #ff7c8e;
}

.ni-name {
  font-size: 24rpx;
  color: #424242;
}

.ni-val {
  font-size: 24rpx;
  font-weight: 600;
  color: #212121;
  flex-shrink: 0;
}

.ni-pct {
  font-size: 24rpx;
  color: #757575;
  flex-shrink: 0;
  min-width: 64rpx;
  text-align: right;
}
</style>
