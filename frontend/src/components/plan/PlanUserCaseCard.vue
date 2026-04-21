<template>
  <view class="plan-user-case-card">
    <view class="plan-user-case-header">
      <text class="header-text">{{ headerTitle }}</text>
    </view>
    <swiper
      class="case-swiper"
      circular
      vertical
      autoplay
      :interval="3400"
      :duration="480"
    >
      <swiper-item v-for="s in slides" :key="s.id">
        <view class="plan-user-case-row">
          <view
            class="avatar"
            :style="{ background: `linear-gradient(145deg, hsl(${s.hue}, 70%, 88%), hsl(${(s.hue + 40) % 360}, 55%, 78%))` }"
          >
            <text class="avatar-letter">{{ s.initial }}</text>
          </view>
          <view class="plan-user-case-main">
            <view class="achievement-row">
              <text class="ach-text">{{ s.weeks }} 周减重 </text>
              <text class="ach-num">{{ s.loss }}</text>
              <text class="ach-text"> 斤</text>
            </view>
          </view>
          <text class="plan-user-case-date">{{ s.month }}月{{ s.day }}日达成</text>
        </view>
      </swiper-item>
    </swiper>
  </view>
</template>

<script setup lang="ts">
import { buildPlanUserCaseSlides } from '@/constants/planUserCases'

defineProps({
  headerTitle: { type: String, default: '真实用户案例' },
})

const slides = buildPlanUserCaseSlides(20)
</script>

<style scoped>
.plan-user-case-card {
  display: flex;
  flex-direction: column;
  gap: 20rpx;
  padding: 32rpx;
  background: #ffffff;
  border-radius: 32rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.06);
}

.plan-user-case-header {
  align-self: flex-start;
  background: #d9efd4;
  border-radius: 32rpx;
  padding: 12rpx 28rpx;
}

.header-text {
  font-size: 24rpx;
  font-weight: 600;
  color: #2e7d32;
}

.case-swiper {
  width: 100%;
  height: 112rpx;
}

.plan-user-case-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 20rpx;
  padding-top: 4rpx;
  height: 100%;
  box-sizing: border-box;
}

.avatar {
  width: 88rpx;
  height: 88rpx;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  border: 2rpx solid rgba(255, 255, 255, 0.85);
}

.avatar-letter {
  font-size: 36rpx;
  font-weight: 700;
  color: #2e4a2e;
}

.plan-user-case-main {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8rpx;
  min-width: 0;
}

.achievement-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  flex-wrap: wrap;
}

.ach-text {
  font-size: 28rpx;
  color: #333333;
}

.ach-num {
  font-size: 32rpx;
  font-weight: 700;
  color: #2e7d32;
}

.plan-user-case-date {
  font-size: 22rpx;
  color: #999999;
  flex-shrink: 0;
}
</style>
