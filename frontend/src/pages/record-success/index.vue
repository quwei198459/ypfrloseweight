<template>
  <view class="record-success-page">
    <scroll-view scroll-y class="page-scroll" :show-scrollbar="false">
      <view class="scroll-inner">
        <view class="success-hero-section">
          <view class="success-hero-text-block">
            <text class="success-title">记录成功！</text>
            <text class="success-subtitle">本次饮食的评价为</text>
          </view>
          <view class="success-illustration-group">
            <text class="illus-emoji">🐼👦</text>
          </view>
        </view>

        <SuccessNutritionCard />

        <NutritionCommentSection />
      </view>
    </scroll-view>

    <view class="fixed-bottom-bar">
      <view class="confirm-button" @click="goDailyRecord">
        <text class="confirm-text">确定</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import SuccessNutritionCard from '@/components/record/SuccessNutritionCard.vue'
import NutritionCommentSection from '@/components/record/NutritionCommentSection.vue'

const goDailyRecord = () => {
  uni.navigateTo({
    url: '/pages/daily-record/index',
  })
}
</script>

<style lang="scss" scoped>
.record-success-page {
  min-height: 100vh;
  background: #f5f5f5;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
}

.page-scroll {
  flex: 1;
  height: 0;
  min-height: 0;
}

.scroll-inner {
  padding: 0 24rpx 144rpx;
  box-sizing: border-box;
}

.success-hero-section {
  background: #d4edb8;
  padding: 40rpx 32rpx 32rpx;
  margin: 0 -24rpx 24rpx;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  gap: 16rpx;
  box-sizing: border-box;
}

.success-hero-text-block {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.success-title {
  font-size: 44rpx;
  font-weight: 700;
  color: #212121;
}

.success-subtitle {
  font-size: 26rpx;
  font-weight: normal;
  color: #424242;
}

.success-illustration-group {
  width: 200rpx;
  height: 176rpx;
  border-radius: 24rpx;
  background: #e8f5e9;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.illus-emoji {
  font-size: 56rpx;
  color: #81c784;
}

.fixed-bottom-bar {
  flex-shrink: 0;
  background: #f5f5f5;
  padding: 24rpx 32rpx calc(24rpx + env(safe-area-inset-bottom));
  box-sizing: border-box;
}

.confirm-button {
  width: 100%;
  height: 96rpx;
  border-radius: 48rpx;
  background: #c1d699;
  display: flex;
  align-items: center;
  justify-content: center;
}

.confirm-text {
  font-size: 32rpx;
  font-weight: 600;
  color: #33691e;
}
</style>
