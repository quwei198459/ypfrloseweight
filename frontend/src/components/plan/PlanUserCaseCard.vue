<template>
  <view class="plan-user-case-card">
    <view class="plan-user-case-header">
      <text class="header-text">{{ headerTitle }}</text>
    </view>
    <view class="plan-user-case-row">
      <view class="avatar image-placeholder">
        <text class="placeholder-text">image-placeholder</text>
      </view>
      <view class="plan-user-case-main">
        <view class="achievement-row">
          <text class="ach-text">{{ achievementPrefix }}</text>
          <text class="ach-num">{{ lossValue }}</text>
          <text class="ach-text">{{ unit }}</text>
        </view>
      </view>
      <text class="plan-user-case-date">{{ achievedDate }}</text>
    </view>
  </view>
</template>

<script setup>
defineProps({
  headerTitle: { type: String, default: '真实用户案例' },
  achievementPrefix: { type: String, default: '18 周减重 ' },
  lossValue: { type: [String, Number], required: true },
  unit: { type: String, default: ' 斤' },
  achievedDate: { type: String, required: true },
})
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

.plan-user-case-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 20rpx;
  padding-top: 8rpx;
}

.avatar {
  width: 88rpx;
  height: 88rpx;
  border-radius: 50%;
  background: #eef3ee;
  border: 1rpx solid #c8d8c8;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.placeholder-text {
  font-size: 18rpx;
  color: #7a8f7a;
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
