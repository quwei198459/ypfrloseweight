<template>
  <view class="plan-progress-card">
    <view class="headline-pill">
      <text class="headline-text">计划在 {{ planWeeks }} 周减重 {{ totalLoss }} {{ lossUnit }}</text>
    </view>
    <text class="social-proof">已有{{ socialProofPercent }}%的人按计划达成目标</text>

    <view class="phase-timeline">
      <view class="section-title-pill">
        <text class="section-title-text">{{ sectionTitle }}</text>
      </view>
      <view class="phase-curve-line">
        <view class="phase-string-line" />
      </view>
      <view class="phase-polaroid-row">
        <view v-for="(p, idx) in phaseList" :key="idx" class="phase-item">
          <view class="polaroid-inner image-placeholder">
            <text class="placeholder-text">image-placeholder</text>
          </view>
          <text class="phase-name">{{ p.phaseName }}</text>
        </view>
      </view>
    </view>

    <view class="chart-container">
      <text class="chart-hint">{{ chartHint }}</text>
      <view class="weight-range-display">
        <block v-for="(m, mi) in milestones" :key="mi">
          <text class="milestone" :style="{ color: m.color }">{{ m.value }}{{ unit }}</text>
          <text v-if="mi < milestones.length - 1" class="arrow" :style="{ color: m.arrowColor || m.color }">
            {{ arrowSymbol }}
          </text>
        </block>
      </view>
    </view>
  </view>
</template>

<script setup>
defineProps({
  planWeeks: { type: Number, required: true },
  totalLoss: { type: Number, required: true },
  lossUnit: { type: String, default: '斤' },
  socialProofPercent: { type: Number, required: true },
  sectionTitle: { type: String, default: '减脂是最好的逆袭' },
  phaseList: {
    type: Array,
    default: () => [
      { phaseName: '启动' },
      { phaseName: '减脂' },
      { phaseName: '巩固' },
    ],
  },
  chartHint: { type: String, default: '体重趋势（占位）' },
  milestones: {
    type: Array,
    default: () => [
      { value: 170, color: '#e53935', arrowColor: '#e53935' },
      { value: 150, color: '#fb8c00', arrowColor: '#43a047' },
      { value: 120, color: '#2e7d32' },
    ],
  },
  unit: { type: String, default: '斤' },
  arrowSymbol: { type: String, default: '>>>>' },
})
</script>

<style scoped>
.plan-progress-card {
  display: flex;
  flex-direction: column;
  gap: 28rpx;
  padding: 32rpx;
  background: #ffffff;
  border-radius: 32rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.06);
}

.headline-pill {
  align-self: flex-start;
  background: #d9efd4;
  border-radius: 40rpx;
  padding: 16rpx 32rpx;
}

.headline-text {
  font-size: 26rpx;
  font-weight: 600;
  color: #2e7d32;
}

.social-proof {
  font-size: 24rpx;
  color: #666666;
}

.phase-timeline {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}

.section-title-pill {
  align-self: flex-start;
  background: #d9efd4;
  border-radius: 36rpx;
  padding: 12rpx 28rpx;
}

.section-title-text {
  font-size: 24rpx;
  font-weight: 600;
  color: #2e7d32;
}

.phase-curve-line {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  min-height: 56rpx;
}

.phase-string-line {
  width: 100%;
  height: 6rpx;
  background: #f5d76e;
  border-radius: 4rpx;
}

.phase-polaroid-row {
  display: flex;
  flex-direction: row;
  justify-content: center;
  gap: 16rpx;
  flex-wrap: wrap;
}

.phase-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8rpx;
}

.polaroid-inner {
  width: 160rpx;
  height: 144rpx;
  background: #ffffff;
  border-radius: 8rpx;
  box-shadow: 0 4rpx 12rpx rgba(0, 0, 0, 0.12);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 8rpx;
}

.placeholder-text {
  font-size: 18rpx;
  color: #889988;
}

.phase-name {
  font-size: 18rpx;
  color: #666666;
}

.chart-container {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}

.chart-hint {
  font-size: 20rpx;
  color: #999999;
}

.weight-range-display {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  flex-wrap: wrap;
  gap: 8rpx;
  padding-top: 8rpx;
}

.milestone {
  font-size: 28rpx;
  font-weight: 700;
}

.arrow {
  font-size: 24rpx;
}
</style>
