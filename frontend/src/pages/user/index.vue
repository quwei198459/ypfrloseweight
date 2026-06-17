<template>
  <view class="me-page">
    <scroll-view scroll-y enable-flex class="me-scroll" :show-scrollbar="false">
      <view class="me-hero">
        <view class="me-hero__bg" />
        <view class="me-hero__dots" aria-hidden="true">
          <view class="dot dot--1" />
          <view class="dot dot--2" />
          <view class="dot dot--3" />
        </view>

        <view class="me-hero__inner">
          <view class="me-hero__row">
            <view class="avatar-block">
              <view class="avatar-frame">
                <image
                  v-if="avatarSrc"
                  class="user-avatar user-avatar--img"
                  :src="avatarSrc"
                  mode="aspectFill"
                />
                <view v-else class="user-avatar user-avatar--ph" />
                <view v-if="userStore.isLogin" class="edit-badge" @click.stop="goAccountEdit">
                  <text class="edit-badge__ico">✎</text>
                </view>
              </view>
              <view class="user-meta">
                <text class="user-name">{{ userStore.isLogin ? profileData.nickname || '用户' : '未登录' }}</text>
                <text class="user-joined">{{ joinedLine }}</text>
              </view>
            </view>
            <view v-if="!userStore.isLogin" class="hero-login-btn" @click="goLogin">
              <text class="hero-login-btn__text">去登录</text>
            </view>
            <view v-else class="panda-slot" aria-hidden="true">
              <text class="panda-emoji">🐼</text>
            </view>
          </view>
        </view>

        <view class="me-stats-wrap">
          <UserStatsCard :record-count="profileData.mealRecordCount" :healthy-days="profileData.healthyDietDays" />
        </view>
      </view>

      <view class="me-body">
        <view v-if="!userStore.isLogin" class="login-guide-card" @click="goLogin">
          <view class="login-guide-copy">
            <text class="login-guide-title">登录后查看您的减脂数据</text>
            <text class="login-guide-desc">饮食记录、体重趋势和健康饮食天数会在登录后同步展示</text>
          </view>
          <view class="login-guide-btn">
            <text class="login-guide-btn__text">立即登录</text>
          </view>
        </view>
        <UserBannerCard @action="onBannerTap" />
        <view class="me-grid">
          <view
            class="me-grid__item me-grid__nav"
            hover-class="me-grid__nav-hover"
            hover-stay-time="70"
            role="button"
            aria-label="打开近7日数据统计"
            @tap.stop="goWeekStats"
          >
            <UserHomeMetricCard title="数据统计" :value="weekDeficitSummary" desc="最近7天热量缺口" />
          </view>
          <view
            class="me-grid__item me-grid__nav"
            hover-class="me-grid__nav-hover"
            hover-stay-time="70"
            role="button"
            aria-label="打开减脂趋势"
            @tap.stop="goWeightTrend"
          >
            <UserHomeMetricCard title="当前体重" :value="profileData.currentWeight" :desc="weightRecordDesc" />
          </view>
        </view>
        <view v-if="userStore.isLogin" class="logout-card" @click="onLogout">
          <text class="logout-card__text">退出账户</text>
        </view>
        <view class="me-bottom-gap" />
      </view>
    </scroll-view>
  </view>
</template>

<script setup lang="ts">
import { onShow } from '@dcloudio/uni-app'
import { storeToRefs } from 'pinia'
import { computed, ref } from 'vue'
import { fetchWeekStats } from '@/api/loseweight'
import { getRolling7DaysRange } from '@/utils/rolling7Days'
import { useUserStore } from '@/stores/user'
import UserBannerCard from '../../components/user/UserBannerCard.vue'
import UserHomeMetricCard from '../../components/user/UserHomeMetricCard.vue'
import UserStatsCard from '../../components/user/UserStatsCard.vue'
import { useUserProfileStore } from '../../stores/userProfile'

const store = useUserProfileStore()
const userStore = useUserStore()
const { profileData } = storeToRefs(store)

/** 后端头像 URL（相对路径会拼 API 根地址） */
const avatarSrc = computed(() => profileData.value.avatar?.trim() || '')

const joinedLine = computed(() => {
  if (!userStore.isLogin) return '登录后查看个人数据'
  const d = profileData.value.joinedDays
  if (d != null && d >= 1) return `已加入 ${d} 天`
  return '已加入 —'
})

/** 当前展示体重相对「最近一次称重打卡」的说明（体重数值仍来自资料 currentWeightKg） */
const weightRecordDesc = computed(() => {
  const ago = profileData.value.weightRecordedDaysAgo
  if (ago === null) return '无单独称重记录'
  if (ago <= 0) return '今日有称重记录'
  return `${ago} 天前有称重记录`
})

const weekDeficitSummary = ref('0千卡')

function syncProfile() {
  if (!userStore.isLogin) {
    store.resetProfile()
    return
  }
  userStore.fetchUserProfile()
    .then((user) => {
      if (user) store.applyFromApiUser(user)
    })
    .catch((e: Error) => {
      store.resetProfile()
      uni.showToast({ title: e.message || '资料加载失败', icon: 'none' })
    })
}

function syncWeekDeficitSummary() {
  if (!userStore.isLogin) {
    weekDeficitSummary.value = '--'
    return
  }
  const { startDate, endDate } = getRolling7DaysRange()
  fetchWeekStats(startDate, endDate)
    .then((data) => {
      const c0 = data.cards?.[0]
      if (c0) {
        const v = Math.round(Number(c0.totalValue) || 0)
        const suf = c0.totalSuffix || '千卡'
        weekDeficitSummary.value = `${v}${suf}`
      } else {
        weekDeficitSummary.value = '0千卡'
      }
    })
    .catch(() => {
      weekDeficitSummary.value = '--'
    })
}

onShow(() => {
  syncProfile()
  void syncWeekDeficitSummary()
})

const ACCOUNT_EDIT = '/pages/user/account-edit'
const WEEK_STATS = '/pages/user/week-stats'
const WEIGHT_TREND = '/pages/user/weight-trend'

function goAccountEdit() {
  uni.navigateTo({ url: ACCOUNT_EDIT })
}

function goWeekStats() {
  if (!userStore.isLogin) {
    goLogin()
    return
  }
  uni.navigateTo({ url: WEEK_STATS })
}

function goWeightTrend() {
  if (!userStore.isLogin) {
    goLogin()
    return
  }
  uni.navigateTo({ url: WEIGHT_TREND })
}

function goLogin() {
  uni.navigateTo({ url: '/pages/login/index' })
}

function onBannerTap() {
  uni.showToast({ title: '敬请期待', icon: 'none' })
}

function onLogout() {
  uni.showModal({
    title: '退出账户',
    content: '退出后，本机将清空登录状态和个人数据展示。',
    confirmText: '退出',
    confirmColor: '#d93025',
    success: (res) => {
      if (!res.confirm) return
      userStore.logout()
      store.resetProfile()
      weekDeficitSummary.value = '--'
      uni.showToast({ title: '已退出', icon: 'success' })
    },
  })
}

</script>

<style lang="scss" scoped>
$hero-green: #cfe6a5;
$me-page-bg: #f6f6f6;

.me-page {
  min-height: 100vh;
  background: $me-page-bg;
  display: flex;
  flex-direction: column;
}

.me-scroll {
  flex: 1;
  height: 100%;
  box-sizing: border-box;
}

.me-hero {
  position: relative;
  padding-bottom: 0;
}

.me-hero__bg {
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 320rpx;
  background: $hero-green;
}

.me-hero__dots {
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 320rpx;
  pointer-events: none;
  z-index: 1;
}

.dot {
  position: absolute;
  border-radius: 50%;
  background: #fff;
}

.dot--1 {
  width: 12rpx;
  height: 12rpx;
  left: 48rpx;
  top: 72rpx;
  opacity: 0.22;
}

.dot--2 {
  width: 10rpx;
  height: 10rpx;
  left: 400rpx;
  top: 104rpx;
  opacity: 0.18;
}

.dot--3 {
  width: 14rpx;
  height: 14rpx;
  left: 600rpx;
  top: 56rpx;
  opacity: 0.15;
}

.me-hero__inner {
  position: relative;
  z-index: 2;
  padding: calc(env(safe-area-inset-top) + 28rpx) 32rpx 28rpx;
  box-sizing: border-box;
}

.me-hero__row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  gap: 12rpx;
}

.avatar-block {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 12rpx;
  flex: 1;
  min-width: 0;
}

.avatar-frame {
  position: relative;
  width: 128rpx;
  height: 128rpx;
  flex-shrink: 0;
}

.user-avatar {
  width: 128rpx;
  height: 128rpx;
  border-radius: 50%;
  box-sizing: border-box;
}

.user-avatar--img {
  display: block;
  background: #f0f0f0;
}

.user-avatar--ph {
  background: #e0e0e0;
}

.edit-badge {
  position: absolute;
  right: 0;
  bottom: 0;
  width: 52rpx;
  height: 52rpx;
  border-radius: 50%;
  background: #fff;
  box-shadow: 0 4rpx 10rpx rgba(0, 0, 0, 0.1);
  display: flex;
  align-items: center;
  justify-content: center;
}

.edit-badge__ico {
  font-size: 20rpx;
  color: #333;
  line-height: 1;
}

.user-meta {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  justify-content: center;
  gap: 6rpx;
  min-width: 0;
  flex: 1;
  padding-right: 8rpx;
}

.user-name {
  font-size: 34rpx;
  font-weight: 600;
  color: #1a1a1a;
  line-height: 1.28;
}

.user-joined {
  font-size: 24rpx;
  color: #5c5c5c;
  line-height: 1.35;
}

.hero-login-btn {
  flex-shrink: 0;
  height: 64rpx;
  padding: 0 28rpx;
  border-radius: 32rpx;
  background: #ffffff;
  box-shadow: 0 6rpx 18rpx rgba(50, 80, 40, 0.12);
  display: flex;
  align-items: center;
  justify-content: center;
}

.hero-login-btn__text {
  font-size: 28rpx;
  font-weight: 700;
  color: #5ba86d;
}

.panda-slot {
  width: 220rpx;
  height: 180rpx;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.panda-emoji {
  font-size: 112rpx;
  line-height: 1;
  opacity: 0.95;
}

.me-stats-wrap {
  position: relative;
  z-index: 3;
  margin-top: 0rpx;
  padding: 0 32rpx;
  box-sizing: border-box;
}

.me-body {
  padding: 24rpx 32rpx 0;
  margin-top: 14rpx;
  box-sizing: border-box;
}

.login-guide-card {
  margin-bottom: 24rpx;
  padding: 28rpx 28rpx;
  border-radius: 30rpx;
  background: linear-gradient(135deg, #ffffff 0%, #f2f9e9 100%);
  box-shadow: 0 10rpx 28rpx rgba(42, 78, 35, 0.1);
  border: 2rpx solid rgba(91, 168, 109, 0.16);
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20rpx;
}

.login-guide-copy {
  flex: 1;
  min-width: 0;
}

.login-guide-title {
  display: block;
  font-size: 32rpx;
  font-weight: 700;
  color: #22321f;
  line-height: 1.35;
}

.login-guide-desc {
  display: block;
  margin-top: 8rpx;
  font-size: 24rpx;
  color: #6e7b69;
  line-height: 1.45;
}

.login-guide-btn {
  flex-shrink: 0;
  min-width: 160rpx;
  height: 68rpx;
  border-radius: 34rpx;
  background: #bfd98e;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 24rpx;
}

.login-guide-btn__text {
  font-size: 26rpx;
  font-weight: 700;
  color: #24351f;
}

.me-grid {
  margin-top: 36rpx;
  display: flex;
  flex-direction: row;
  align-items: stretch;
  gap: 16rpx;
}

/* 等宽两列：不用 50% + gap（小程序 scroll-view 里百分比基准易偏），用 flex-basis:0 均分剩余空间 */
.me-grid__item {
  flex: 1 1 0;
  min-width: 0;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
}

.me-grid__nav-hover {
  opacity: 0.92;
}

.logout-card {
  margin-top: 28rpx;
  height: 88rpx;
  border-radius: 28rpx;
  background: #fff;
  box-shadow: 0 8rpx 24rpx rgba(20, 36, 26, 0.06);
  display: flex;
  align-items: center;
  justify-content: center;
}

.logout-card__text {
  font-size: 30rpx;
  font-weight: 600;
  color: #d93025;
}

.me-bottom-gap {
  height: calc(120rpx + env(safe-area-inset-bottom));
}
</style>
