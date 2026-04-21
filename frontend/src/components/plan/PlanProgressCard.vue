<template>
  <view class="plan-progress-card">
    <view class="headline-pill">
      <text class="headline-text">计划在 {{ planWeeks }} 周减重 {{ totalLoss }} {{ lossUnit }}</text>
    </view>
    <text class="social-proof">已有{{ socialProofPercent }}%的人按计划达成目标</text>

    <view class="section-title-pill">
      <text class="section-title-text">{{ sectionTitle }}</text>
    </view>
    <image
      class="banner-img"
      src="/static/plan/plan-transformation.png"
      mode="widthFix"
    />

    <view class="weight-range-display">
      <block v-for="(m, mi) in milestones" :key="mi">
        <text class="milestone" :style="{ color: m.color }">{{ m.value }}{{ unit }}</text>
        <text v-if="mi < milestones.length - 1" class="arrow" :style="{ color: m.arrowColor || m.color }">
          {{ arrowSymbol }}
        </text>
      </block>
    </view>

    <image
      class="banner-img phase-banner"
      src="/static/plan/phase-timeline.png"
      mode="widthFix"
    />
    <view v-if="timelineStartLabel && timelineEndLabel" class="timeline-dates">
      <text class="date-l">{{ timelineStartLabel }}</text>
      <text class="date-r">{{ timelineEndLabel }}</text>
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
  timelineStartLabel: { type: String, default: '' },
  timelineEndLabel: { type: String, default: '' },
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
  gap: 24rpx;
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

.banner-img {
  width: 100%;
  display: block;
  border-radius: 16rpx;
}

.phase-banner {
  margin-top: 4rpx;
}

.weight-range-display {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  flex-wrap: wrap;
  gap: 8rpx;
  padding: 4rpx 0 8rpx;
}

.milestone {
  font-size: 28rpx;
  font-weight: 700;
}

.arrow {
  font-size: 24rpx;
}

.timeline-dates {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  padding: 0 8rpx 4rpx;
  margin-top: -8rpx;
}

.date-l,
.date-r {
  font-size: 22rpx;
  color: #888888;
}
</style>
