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

        <view v-if="!userStore.isLogin" class="home-login-card" @click="goLogin">
          <view class="home-login-copy">
            <text class="home-login-title">登录后开始记录热量</text>
            <text class="home-login-desc">同步饮食、运动和体重数据，生成您的减脂计划</text>
          </view>
          <view class="home-login-btn">
            <text class="home-login-btn__text">去登录</text>
          </view>
        </view>

        <view v-if="showProfileQuickCard" class="profile-quick-card">
          <view class="profile-quick-copy" @click="goAccountEdit">
            <text class="profile-quick-title">完善微信资料</text>
            <text class="profile-quick-desc">绑定手机号、同步头像，方便使用识别与报告服务</text>
          </view>
          <view class="profile-quick-actions">
            <!-- #ifdef MP-WEIXIN -->
            <button
              v-if="needBindPhone"
              class="profile-quick-btn profile-quick-btn--primary"
              open-type="getPhoneNumber"
              hover-class="none"
              @getphonenumber="onHomePhoneAuth"
            >
              绑定手机号
            </button>
            <button
              v-if="needSyncAvatar"
              class="profile-quick-btn"
              open-type="chooseAvatar"
              hover-class="none"
              @chooseavatar="onHomeChooseAvatar"
            >
              同步头像
            </button>
            <!-- #endif -->
            <!-- #ifndef MP-WEIXIN -->
            <view class="profile-quick-btn profile-quick-btn--primary" @click="goAccountEdit">去完善</view>
            <!-- #endif -->
          </view>
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

      <!-- Skin Detection Entry -->
      <view v-if="showSkinEntry" class="skin-entry-section">
        <view class="skin-entry-card" @click="goSkinDetection">
          <view class="skin-entry-copy">
            <text class="skin-entry-kicker">AI 皮肤检测</text>
            <text class="skin-entry-title">拍照生成肤况报告</text>
            <text class="skin-entry-desc">斑点、毛孔、肤质、痤疮、皱纹、黑头 6 项分析</text>
          </view>
          <view class="skin-entry-button">去检测</view>
        </view>
      </view>

      <!-- TCM Detection Entry -->
      <view v-if="showTcmEntry" class="tcm-entry-section">
        <view class="tcm-entry-card" @click="goTcmDetection">
          <view class="tcm-entry-copy">
            <text class="tcm-entry-kicker">中医 AI 体检</text>
            <text class="tcm-entry-title">AI 舌诊 · 面诊 · 体质辨识</text>
            <text class="tcm-entry-desc">拍舌象面象，生成中医体质与健康调理报告</text>
          </view>
          <view class="tcm-entry-button">去检测</view>
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
import { computed, ref } from 'vue'
import { fetchDashboard } from '@/api/loseweight'
import { fetchHomeEntryConfig } from '@/api/appConfig'
import logoContrast from '@/static/logo/logo-c-contrast.png'
import HomeCalorieGauge from '@/components/home/HomeCalorieGauge.vue'
import { formatLocalDate } from '@/utils/date'
import { useUserStore } from '@/stores/user'
import { useUserProfileStore } from '@/stores/userProfile'

const MEAL_ICON_STORAGE = 'ypfw_meal_icon_active'

const userStore = useUserStore()
const profileStore = useUserProfileStore()

const intakeCalories = ref(0)
const remainingCalories = ref(0)
const sportCalories = ref(0)
const dailyBudget = ref(0)
const mealIconActiveKey = ref<string | null>(null)
/** 首页入口可见性（后台可控）；默认显示，接口失败也保持显示，避免误隐藏 */
const showSkinEntry = ref(true)
const showTcmEntry = ref(true)

const needBindPhone = computed(() => !userStore.userInfo?.phone)
const needSyncAvatar = computed(() => !userStore.userInfo?.avatarUrl)
const showProfileQuickCard = computed(() => userStore.isLogin && (needBindPhone.value || needSyncAvatar.value))

function syncProfile() {
  if (!userStore.token) return
  userStore.fetchUserProfile()
    .then((u) => {
      if (u) profileStore.applyFromApiUser(u)
    })
    .catch(() => {})
}

function readFileAsBase64(filePath: string): Promise<string | undefined> {
  return new Promise((resolve) => {
    uni.getFileSystemManager().readFile({
      filePath,
      encoding: 'base64',
      success: (r) => {
        const d = r.data
        resolve(typeof d === 'string' ? d : undefined)
      },
      fail: () => resolve(undefined),
    })
  })
}

async function onHomePhoneAuth(e: { detail?: { errMsg?: string; code?: string } }) {
  const d = e.detail
  if (!d?.errMsg || !d.errMsg.includes('getPhoneNumber:ok')) {
    uni.showToast({ title: '未授权手机号', icon: 'none' })
    return
  }
  if (!d.code) {
    uni.showToast({ title: '请升级微信或基础库以支持手机号', icon: 'none' })
    return
  }
  try {
    await userStore.bindPhone(d.code)
    if (userStore.userInfo) profileStore.applyFromApiUser(userStore.userInfo)
    uni.showToast({ title: '手机号已绑定', icon: 'success' })
  } catch (err: unknown) {
    uni.showToast({ title: err instanceof Error ? err.message : '绑定失败', icon: 'none' })
  }
}

async function onHomeChooseAvatar(e: { detail?: { avatarUrl?: string } }) {
  const avatarUrl = e.detail?.avatarUrl
  if (!avatarUrl) return
  try {
    uni.showLoading({ title: '同步中', mask: true })
    const b64 = await readFileAsBase64(avatarUrl)
    if (!b64) throw new Error('头像读取失败')
    const u = await userStore.updateUserProfile({ avatarBase64: `data:image/jpeg;base64,${b64}` })
    profileStore.applyFromApiUser(u)
    uni.hideLoading()
    uni.showToast({ title: '头像已同步', icon: 'success' })
  } catch (err: unknown) {
    uni.hideLoading()
    uni.showToast({ title: err instanceof Error ? err.message : '同步失败', icon: 'none' })
  }
}

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
  if (!userStore.isLogin) {
    intakeCalories.value = 0
    sportCalories.value = 0
    dailyBudget.value = 0
    remainingCalories.value = 0
    return
  }
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

function syncHomeEntryConfig() {
  fetchHomeEntryConfig()
    .then((cfg) => {
      showSkinEntry.value = cfg.skinDetectionEntryVisible !== false
      showTcmEntry.value = cfg.tcmDetectionEntryVisible !== false
    })
    .catch(() => {
      // 接口异常时保持默认显示，避免误隐藏入口
    })
}

onShow(() => {
  syncProfile()
  syncDashboard()
  syncMealIconHighlight()
  syncHomeEntryConfig()
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

const goAccountEdit = () => {
  uni.navigateTo({
    url: '/pages/user/account-edit',
  })
}

const goLogin = () => {
  uni.navigateTo({
    url: '/pages/login/index',
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

const goSkinDetection = () => {
  uni.navigateTo({
    url: '/pages/skin-detection/intro',
  })
}

const goTcmDetection = () => {
  uni.navigateTo({
    url: '/pages/tcm-detection/intro',
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

.profile-quick-card,
.home-login-card {
  position: relative;
  z-index: 1;
  margin: 12px 16px 0;
  padding: 12px 14px;
  border-radius: 18px;
  background: rgba(255, 255, 255, 0.94);
  box-shadow: 0 8px 20px rgba(68, 104, 61, 0.12);
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.home-login-card {
  background: linear-gradient(135deg, #ffffff 0%, #f2f9e9 100%);
  border: 1px solid rgba(91, 168, 109, 0.16);
}

.profile-quick-copy,
.home-login-copy {
  flex: 1;
  min-width: 0;
}

.profile-quick-title,
.home-login-title {
  display: block;
  font-size: 15px;
  font-weight: 700;
  color: #243323;
  line-height: 1.3;
}

.profile-quick-desc,
.home-login-desc {
  display: block;
  margin-top: 3px;
  font-size: 11px;
  color: #72806e;
  line-height: 1.35;
}

.profile-quick-actions {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
}

.profile-quick-btn,
.home-login-btn {
  margin: 0;
  padding: 0 12px;
  height: 30px;
  line-height: 30px;
  border-radius: 15px;
  border: none;
  background: #eef7df;
  color: #5d7f3f;
  font-size: 12px;
  font-weight: 700;
}

.home-login-btn {
  flex-shrink: 0;
  background: #bfd98e;
  color: #23351d;
  display: flex;
  align-items: center;
  justify-content: center;
}

.home-login-btn__text {
  font-size: 12px;
  font-weight: 700;
  color: #23351d;
}

.profile-quick-btn--primary {
  background: #bfd98e;
  color: #23351d;
}

.profile-quick-btn::after {
  border: none;
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

// ===== Skin Detection Entry =====
.skin-entry-section {
  padding: 17px 16px 0;
}

.skin-entry-card {
  min-height: 116px;
  padding: 18px 18px;
  border-radius: 24px;
  background: linear-gradient(135deg, #ffffff 0%, #eef6e8 100%);
  border: 1px solid #edf1e7;
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-sizing: border-box;
}

.skin-entry-copy {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
}

.skin-entry-kicker {
  font-size: 12px;
  color: #5fa854;
  font-weight: 800;
}

.skin-entry-title {
  margin-top: 6px;
  font-size: 20px;
  font-weight: 900;
  color: #1f2a1f;
}

.skin-entry-desc {
  margin-top: 7px;
  font-size: 12px;
  line-height: 1.5;
  color: #7a857a;
}

.skin-entry-button {
  margin-left: 12px;
  width: 78px;
  height: 36px;
  border-radius: 18px;
  background: #d5e7b1;
  border: 1px solid #9ebc86;
  color: #4b5b2d;
  font-size: 14px;
  font-weight: 800;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

// ===== TCM Detection Entry =====
.tcm-entry-section {
  padding: 17px 16px 0;
}

.tcm-entry-card {
  min-height: 116px;
  padding: 18px 18px;
  border-radius: 24px;
  background: linear-gradient(135deg, #fffdf6 0%, #f4ecda 100%);
  border: 1px solid #efe6d2;
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-sizing: border-box;
}

.tcm-entry-copy {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
}

.tcm-entry-kicker {
  font-size: 12px;
  color: #b5894e;
  font-weight: 800;
}

.tcm-entry-title {
  margin-top: 6px;
  font-size: 20px;
  font-weight: 900;
  color: #2a2419;
}

.tcm-entry-desc {
  margin-top: 7px;
  font-size: 12px;
  line-height: 1.5;
  color: #897e6a;
}

.tcm-entry-button {
  margin-left: 12px;
  width: 78px;
  height: 36px;
  border-radius: 18px;
  background: #ead9b0;
  border: 1px solid #cdb074;
  color: #6b5320;
  font-size: 14px;
  font-weight: 800;
  display: flex;
  align-items: center;
  justify-content: center;
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
