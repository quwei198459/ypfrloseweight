<template>
  <view class="home-page">
    <view class="page-container">
      <!-- Top Hero Section -->
      <view class="top-hero-section">
        <view class="hero-bg"></view>

        <!-- Brand Row -->
        <view class="brand-row">
          <view class="app-logo-pedestal">
            <image class="app-logo" :src="logoContrast" mode="heightFix" />
          </view>
          <text class="app-title">宝护健康瘦</text>
        </view>

        <!-- Search Bar -->
        <view class="search-bar" @click="goHeatSearch">
          <image
            class="search-bar-icon search-bar-icon--left"
            src="/static/icons/search.png"
            mode="aspectFit"
          />
          <text class="search-placeholder">10w+食物库热量查询</text>
          <image
            class="search-bar-icon search-bar-icon--right"
            src="/static/icons/camera.png"
            mode="aspectFit"
            @click.stop="openPhotographFromSearchBar"
          />
        </view>

        <!-- Summary Card -->
        <view class="summary-card">
          <view class="summary-top-row">
            <view class="summary-col summary-col-side">
              <text class="intake-label">饮食摄入</text>
              <text class="intake-value">{{ intakeCalories }}</text>
            </view>

            <view class="summary-col summary-col-center">
              <HomeCalorieGauge
                :value="remainingCalories"
                :max="dailyBudget"
                status="normal"
                :clickable="true"
                :show-arrow="true"
                @click-help="goCustomBmrHelp"
                @click-value="goFoodRecord"
              />
            </view>

            <view class="summary-col summary-col-side">
              <text class="sport-label">运动消耗</text>
              <text class="sport-value">{{ sportCalories }}</text>
            </view>
          </view>

          <view class="divider-line"></view>

          <view class="quick-entry-row">
            <view class="meal-entry" @click="handleMealEntry('breakfast')">
              <image
                class="entry-icon-img"
                :src="categoryIconSrc('breakfast')"
                mode="aspectFit"
              />
              <text class="entry-label">早餐</text>
              <view class="entry-add-button">+</view>
            </view>
            <view class="meal-entry" @click="handleMealEntry('lunch')">
              <image
                class="entry-icon-img"
                :src="categoryIconSrc('lunch')"
                mode="aspectFit"
              />
              <text class="entry-label">午餐</text>
              <view class="entry-add-button">+</view>
            </view>
            <view class="meal-entry" @click="handleMealEntry('dinner')">
              <image
                class="entry-icon-img"
                :src="categoryIconSrc('dinner')"
                mode="aspectFit"
              />
              <text class="entry-label">晚餐</text>
              <view class="entry-add-button">+</view>
            </view>
            <view class="meal-entry" @click="handleMealEntry('snack')">
              <image
                class="entry-icon-img"
                :src="categoryIconSrc('snack')"
                mode="aspectFit"
              />
              <text class="entry-label">加餐</text>
              <view class="entry-add-button">+</view>
            </view>
            <view class="meal-entry" @click="handleMealEntry('sport')">
              <image
                class="entry-icon-img"
                :src="categoryIconSrc('sport')"
                mode="aspectFit"
              />
              <text class="entry-label">运动</text>
              <view class="entry-add-button">+</view>
            </view>
          </view>
        </view>
      </view>

      <!-- Fat Loss Plan Section -->
      <view class="fat-loss-plan-section">
        <view class="plan-banner-card">
          <image
            class="banner-illustration"
            src="/static/home/fat-loss-plan-banner.png"
            mode="aspectFill"
          />
          <view class="plan-content-overlay">
            <view class="plan-text-group">
              <text class="plan-title">邀请您加入减脂计划</text>
              <text class="plan-subtitle">24928 人正在使用</text>
            </view>
            <view class="plan-cta-button" @click="goToPlanResult">
              <text class="plan-btn-text">免费开启计划</text>
            </view>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { onShow } from '@dcloudio/uni-app'
import { ref } from 'vue'
import { fetchDashboard } from '@/api/loseweight'
import logoContrast from '@/static/logo/logo-c-contrast.png'
import HomeCalorieGauge from '@/components/home/HomeCalorieGauge.vue'
import { formatLocalDate } from '@/utils/date'

const MEAL_ICON_STORAGE = 'ypfw_meal_icon_active'

const intakeCalories = ref(0)
const remainingCalories = ref(0)
const sportCalories = ref(0)
const dailyBudget = ref(0)
const mealIconActiveKey = ref<string | null>(null)

function syncMealIconHighlight() {
  const v = uni.getStorageSync(MEAL_ICON_STORAGE)
  mealIconActiveKey.value = typeof v === 'string' && v.length > 0 ? v : null
}

function categoryIconSrc(mealKey: string): string {
  const on = mealIconActiveKey.value === mealKey
  return on
    ? `/static/category/category-${mealKey}-active.png`
    : `/static/category/category-${mealKey}.png`
}

function syncDashboard() {
  const date = formatLocalDate(new Date())
  fetchDashboard(date)
    .then((data) => {
      intakeCalories.value = data.intakeCalories
      sportCalories.value = data.sportCalories
      dailyBudget.value = data.dailyBudget
      remainingCalories.value = data.remainingCalories
    })
    .catch((e: Error) => {
      uni.showToast({ title: e.message || '首页数据加载失败', icon: 'none' })
    })
}

onShow(() => {
  syncDashboard()
  syncMealIconHighlight()
})

const handleMealEntry = (mealType: string) => {
  uni.setStorageSync(MEAL_ICON_STORAGE, mealType)
  mealIconActiveKey.value = mealType

  if (mealType === 'sport') {
    uni.navigateTo({ url: '/pages/sport-search/index' })
    return
  }

  const mealMap: Record<string, string> = {
    breakfast: 'breakfast',
    lunch: 'lunch',
    dinner: 'dinner',
    snack: 'snack',
  }

  const mt = mealMap[mealType] || 'breakfast'
  const date = formatLocalDate(new Date())
  uni.navigateTo({
    url: `/pages/food-search/index?mealType=${mt}&date=${encodeURIComponent(date)}`,
  })
}

const goFoodRecord = () => {
  uni.navigateTo({
    url: '/pages/daily-record/index',
  })
}

const goCustomBmrHelp = () => {
  uni.navigateTo({
    url: '/pages/home-budget-help/index',
  })
}

const goToPlanResult = () => {
  uni.navigateTo({
    url: '/pages/plan-result/index',
  })
}

const goHeatSearch = () => {
  uni.navigateTo({
    url: '/pages/search/index',
  })
}

const openPhotographFromSearchBar = () => {
  uni.navigateTo({
    url: '/pages/photograph/index',
  })
}
</script>

<style lang="scss" scoped>
// ===== Page =====
.home-page {
  width: 100%;
  min-height: 100vh;
  background-color: #f7fbf7;
}

.page-container {
  width: 100%;
  padding-bottom: calc(56px + env(safe-area-inset-bottom));
}

// ===== Top Hero Section =====
.top-hero-section {
  position: relative;
  width: 100%;
  padding-bottom: 0px;
}

.hero-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 226px;
  background-color: #bfd9a3;
  border-radius: 0 0 24px 24px;
  z-index: 0;
}

// Brand Row
.brand-row {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  padding: 44px 16px 0;
  min-height: 44px;
}

/* 轻量白底托（方案 A）：与浅绿顶栏分层，logo 清晰可读 */
.app-logo-pedestal {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 6rpx;
  background: rgba(255, 255, 255, 0.35);
  border-radius: 12rpx;
}

.app-logo {
  width: auto;
  height: 36rpx;
  display: block;
  box-sizing: border-box;
  image-rendering: -webkit-optimize-contrast;
}

.app-title {
  margin-left: 10px;
  font-size: 20px;
  font-weight: 800;
  color: #1f2a1f;
}

// Search Bar
.search-bar {
  position: relative;
  z-index: 1;
  display: flex;
  align-items: center;
  margin: 26px 16px 0;
  height: 40px;
  background-color: #ffffff;
  border: 2px solid #9ebc86;
  border-radius: 20px;
  padding: 0 12px;
}

.search-bar-icon {
  flex-shrink: 0;
}

.search-bar-icon--left {
  width: 22px;
  height: 22px;
}

.search-bar-icon--right {
  width: 26px;
  height: 26px;
}

.search-placeholder {
  flex: 1;
  margin-left: 10px;
  font-size: 14px;
  color: #b3b3b3;
}

// ===== Summary Card（三列 flex + 独立半圆组件）=====
.summary-card {
  position: relative;
  z-index: 1;
  margin: 16px 16px 0;
  min-height: 292px;
  background-color: #ffffff;
  border: 1px solid #e9e2d3;
  border-radius: 20px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
}

.summary-top-row {
  display: flex;
  flex-direction: row;
  flex-wrap: nowrap;
  justify-content: space-between;
  align-items: center;
  padding: 20px 12px 10px;
  box-sizing: border-box;
  flex-shrink: 0;
}

.summary-col-side {
  width: 78px;
  flex: 0 0 78px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 140px;
  box-sizing: border-box;
}

.summary-col-center {
  flex: 1;
  min-width: 0;
  display: flex;
  justify-content: center;
  align-items: center;
}

.intake-label,
.sport-label {
  font-size: 12px;
  color: #333333;
  text-align: center;
  line-height: 1.2;
}

.intake-value,
.sport-value {
  margin-top: 10px;
  font-size: 22px;
  font-weight: 800;
  color: #222222;
  text-align: center;
  line-height: 1.1;
}

.divider-line {
  flex-shrink: 0;
  height: 1px;
  margin: 4px 16px 0;
  background-color: #f1f1f1;
}

// Quick Entry Row
.quick-entry-row {
  flex: 1;
  display: flex;
  flex-direction: row;
  justify-content: space-around;
  align-items: flex-start;
  padding: 14px 10px 16px;
  box-sizing: border-box;
}

.meal-entry {
  width: 54px;
  display: flex;
  flex-direction: column;
  align-items: center;
  padding-top: 0;
}

.entry-icon-img {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  flex-shrink: 0;
  background: rgba(255, 255, 255, 0.65);
  box-sizing: border-box;
}

.entry-label {
  margin-top: 4px;
  font-size: 12px;
  color: #555555;
  text-align: center;
  line-height: 1.4;
}

.entry-add-button {
  margin-top: 8px;
  width: 18px;
  height: 18px;
  background-color: #ffffff;
  border: 1px solid #dddddd;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  color: #dddddd;
  font-weight: bold;
  flex-shrink: 0;
}

// ===== Fat Loss Plan Section =====
.fat-loss-plan-section {
  padding: 17px 16px 0;
}

.plan-banner-card {
  position: relative;
  width: 100%;
  height: 328px;
  background-color: #ffffff;
  border: 1px solid #f0e6d6;
  border-radius: 24px;
  overflow: hidden;
}

.banner-illustration {
  position: absolute;
  left: 20px;
  top: 86px;
  width: 303px;
  height: 220px;
  border: 1px solid #e6ddc8;
  border-radius: 20px;
  overflow: hidden;
  background-color: #f5f1e6;
}

.plan-content-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  padding: 20px;
  box-sizing: border-box;
  z-index: 2;
}

.plan-text-group {
  display: flex;
  flex-direction: column;
}

.plan-title {
  font-size: 20px;
  font-weight: 800;
  color: #1f2a1f;
}

.plan-subtitle {
  margin-top: 10px;
  font-size: 12px;
  color: #8a8a8a;
}

.plan-cta-button {
  position: absolute;
  top: 34px;
  right: 20px;
  width: 120px;
  height: 40px;
  background-color: #d5e7b1;
  border: 2px solid #9ebc86;
  border-radius: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.plan-btn-text {
  font-size: 14px;
  font-weight: 700;
  color: #4b5b2d;
}

</style>
