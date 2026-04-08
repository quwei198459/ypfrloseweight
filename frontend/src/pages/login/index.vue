<template>
  <!-- login_01：默认；login_02：isLogging；login_03：showAgreementPopup -->
  <view class="page">
    <view class="brand">
      <image class="app-icon" src="/static/logo/logo-c-dark.png" mode="aspectFit" />
      <text class="title">瘦多少</text>
      <text class="subtitle">拍一拍，热量知多少</text>
      <text class="login-lite-hint">使用微信账号快速登录</text>
    </view>

    <button
      class="login-btn"
      :class="{ 'login-btn--dim': isLogging }"
      :disabled="isLogging"
      hover-class="none"
      @click="onAccountLogin"
    >
      <text class="login-btn-text">微信登录</text>
    </button>

    <view class="agreement">
      <checkbox-group class="agreement-group" @change="onAgreeChange">
        <checkbox
          class="proto-checkbox"
          value="agree"
          :checked="agreed"
          color="#79C791"
        />
      </checkbox-group>
      <view class="agree-text-wrap">
        <text class="agree-line">
          <text class="agree-plain">我已阅读并同意</text>
          <text class="agree-link" @click.stop="openDoc('terms')">《用户使用协议》</text>
          <text class="agree-plain">和</text>
          <text class="agree-link" @click.stop="openDoc('privacy')">《隐私协议》</text>
        </text>
      </view>
    </view>

    <!-- login_02_status：全屏遮罩 + 居中登录中卡片 -->
    <view v-if="isLogging" class="overlay overlay--dim">
      <view class="loading-card">
        <view class="loading-spinner" />
        <text class="loading-text">登录中</text>
      </view>
    </view>

    <!-- login_03_popup：协议确认（设计稿 Popup/Agreement） -->
    <view v-if="showAgreementPopup" class="overlay overlay--dim">
      <view class="popup-shell" @click.stop>
        <view class="popup">
          <view class="panda-deco">
            <view class="panda-face">
              <view class="panda-eye pe-1" />
              <view class="panda-eye pe-2" />
              <view class="panda-mouth" />
            </view>
          </view>
          <text class="popup-text">我已阅读并同意《用户使用协议》和《隐私协议》</text>
          <view class="popup-actions">
            <button class="popup-btn popup-btn--cancel" hover-class="none" @click="closeAgreementPopup">
              取消
            </button>
            <button class="popup-btn popup-btn--confirm" hover-class="none" @click="confirmAgreementAndLogin">
              确定
            </button>
          </view>
        </view>
      </view>
    </view>

    <view v-if="showDocToast" class="toast">
      <view class="toast-inner">
        <text class="toast-text">{{ docToastMessage }}</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useUserStore } from '@/stores/user'

const userStore = useUserStore()
const agreed = ref(false)
const isLogging = ref(false)
const showAgreementPopup = ref(false)
const showDocToast = ref(false)
const docToastMessage = ref('')

const onAgreeChange = (e: { detail?: { value?: string[] } }) => {
  const vals = e.detail?.value ?? []
  agreed.value = vals.includes('agree')
}

const openDoc = (type: 'privacy' | 'terms') => {
  docToastMessage.value = type === 'privacy' ? '《隐私协议》（静态演示）' : '《用户使用协议》（静态演示）'
  showDocToast.value = true
  setTimeout(() => {
    showDocToast.value = false
  }, 2000)
}

const closeAgreementPopup = () => {
  showAgreementPopup.value = false
}

function finishLoginFail(message: string) {
  isLogging.value = false
  uni.showToast({ title: message, icon: 'none' })
}

async function exchangeCodeAndRoute(code: string) {
  try {
    await userStore.loginByWxCode(code)
    isLogging.value = false
    uni.reLaunch({ url: '/pages/home/index' })
  } catch (e: unknown) {
    const msg = e instanceof Error ? e.message : '登录失败'
    finishLoginFail(msg)
  }
}

/** 仅 wx.login → code；登录后进首页，头像/昵称/手机号由用户在「个人信息」页自行决定 */
const runLoginSuccessFlow = () => {
  if (isLogging.value) return
  isLogging.value = true
  // #ifdef MP-WEIXIN
  uni.login({
    provider: 'weixin',
    success: (res) => {
      if (!res.code) {
        finishLoginFail('未获取登录凭证')
        return
      }
      void exchangeCodeAndRoute(res.code)
    },
    fail: () => finishLoginFail('微信登录失败'),
  })
  // #endif
  // #ifndef MP-WEIXIN
  finishLoginFail('请在微信小程序中打开')
  // #endif
}

const onAccountLogin = () => {
  if (isLogging.value) return
  if (!agreed.value) {
    showAgreementPopup.value = true
    return
  }
  runLoginSuccessFlow()
}

const confirmAgreementAndLogin = () => {
  agreed.value = true
  showAgreementPopup.value = false
  runLoginSuccessFlow()
}
</script>

<style lang="scss" scoped>
/* ========== login_01 设计稿：背景 #F7FBF7 ========== */
.page {
  min-height: 100vh;
  background: #f7fbf7;
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  align-items: center;
  box-sizing: border-box;
  padding-bottom: calc(120rpx + env(safe-area-inset-bottom));
}

.brand {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 200rpx;
}

/* C 方案 logo：紧凑画板、去留白后 96rpx 展示，品牌区居中 */
.app-icon {
  width: 200rpx;
  height: 200rpx;
  border-radius: 12rpx;
  display: block;
  flex-shrink: 0;
  margin: 0 auto;
  image-rendering: -webkit-optimize-contrast;
}

.title {
  margin-top: 28rpx;
  font-size: 44rpx;
  font-weight: 700;
  color: #222222;
  line-height: 1.2;
}

.subtitle {
  margin-top: 16rpx;
  font-size: 26rpx;
  font-weight: 500;
  color: #666666;
  line-height: 1.2;
}

.login-lite-hint {
  margin-top: 24rpx;
  font-size: 24rpx;
  color: #999999;
  line-height: 1.3;
}

/* Button 311×56 → 622×112rpx，圆角 28，描边 2 #5BA86D */
.login-btn {
  width: 622rpx;
  height: 112rpx;
  margin-top: 120rpx;
  padding: 0;
  border-radius: 56rpx;
  background: #79c791;
  border: 4rpx solid #5ba86d;
  display: flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
}

.login-btn::after {
  border: none;
}

.login-btn--dim {
  opacity: 0.65;
}

.login-btn-text {
  color: #ffffff;
  font-size: 36rpx;
  font-weight: 700;
}

/* 底部协议区：勾选 + 文案强制同一行不换行，勾选框缩小与字高协调 */
.agreement {
  position: fixed;
  left: 0;
  right: 0;
  bottom: calc(100rpx + env(safe-area-inset-bottom));
  width: 100%;
  max-width: 100%;
  margin: 0 auto;
  padding: 0 60rpx;
  box-sizing: border-box;
  display: flex;
  flex-direction: row;
  flex-wrap: nowrap;
  align-items: center;
  gap: 16rpx;
}

.agreement-group {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  line-height: 0;
  width: 32rpx;
  height: 32rpx;
}

.proto-checkbox {
  margin: 0;
  width: 28rpx !important;
  height: 28rpx !important;
  transform: scale(0.9);
  transform-origin: center center;
}

/* 外层 view 负责 flex，避免小程序里 text 作 flex 子项异常 */
.agree-text-wrap {
  flex: 1;
  min-width: 0;
  margin-left: 10rpx;
}

/* 单行：一个 text 内嵌多段，整句不换行 */
.agree-line {
  font-size: 22rpx;
  line-height: 32rpx;
  color: #333333;
  white-space: nowrap;
}

.agree-plain {
  font-size: 22rpx;
  color: #333333;
}

.agree-link {
  font-size: 22rpx;
  color: #79c791;
}

/* ========== login_02_status：遮罩 + 160×150 卡片 #4B4B4B 92% ========== */
.overlay {
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 9998;
  display: flex;
  align-items: center;
  justify-content: center;
}

.overlay--dim {
  background: rgba(0, 0, 0, 0.5);
}

.loading-card {
  width: 320rpx;
  height: 300rpx;
  border-radius: 32rpx;
  background: rgba(75, 75, 75, 0.92);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  padding-top: 80rpx;
  box-sizing: border-box;
}

.loading-spinner {
  width: 72rpx;
  height: 72rpx;
  border-radius: 50%;
  border: 8rpx solid #8a8a8a;
  border-top-color: transparent;
  box-sizing: border-box;
  animation: login-spin 0.9s linear infinite;
}

.loading-text {
  margin-top: 32rpx;
  font-size: 32rpx;
  font-weight: 600;
  color: #ffffff;
}

@keyframes login-spin {
  to {
    transform: rotate(360deg);
  }
}

/* ========== login_03_popup：331×210 白底，圆角 20，描边 2 #1A1A1A ========== */
.popup-shell {
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 0 44rpx;
  box-sizing: border-box;
}

.popup {
  width: 662rpx;
  border-radius: 40rpx;
  background: #ffffff;
  border: 4rpx solid #1a1a1a;
  padding: 56rpx 36rpx 36rpx;
  box-sizing: border-box;
  position: relative;
}

.panda-deco {
  position: absolute;
  left: -28rpx;
  top: -44rpx;
  width: 112rpx;
  height: 112rpx;
  pointer-events: none;
}

.panda-face {
  width: 112rpx;
  height: 112rpx;
  border-radius: 56rpx;
  background: #ffffff;
  border: 4rpx solid #1a1a1a;
  position: relative;
  box-sizing: border-box;
}

.panda-eye {
  position: absolute;
  width: 28rpx;
  height: 20rpx;
  border-radius: 14rpx;
  background: #1a1a1a;
  top: 28rpx;
}

.pe-1 {
  left: 22rpx;
}

.pe-2 {
  left: 56rpx;
}

.panda-mouth {
  position: absolute;
  width: 20rpx;
  height: 16rpx;
  border-radius: 10rpx;
  background: #1a1a1a;
  left: 46rpx;
  top: 58rpx;
}

.popup-text {
  font-size: 32rpx;
  font-weight: 700;
  color: #222222;
  line-height: 1.4;
}

.popup-actions {
  margin-top: 36rpx;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  gap: 24rpx;
}

.popup-btn {
  flex: 1;
  height: 112rpx;
  margin: 0;
  padding: 0;
  border-radius: 56rpx;
  font-size: 36rpx;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
}

.popup-btn::after {
  border: none;
}

.popup-btn--cancel {
  background: #ffffff;
  border: 4rpx solid #7a8f5a;
  color: #7a8f5a;
}

.popup-btn--confirm {
  background: #bbd87a;
  border: 4rpx solid #7a8f5a;
  color: #4b5b2d;
}

.toast {
  position: fixed;
  left: 50%;
  bottom: 200rpx;
  transform: translateX(-50%);
  z-index: 10000;
}

.toast-inner {
  padding: 18rpx 26rpx;
  border-radius: 18rpx;
  background: rgba(15, 23, 42, 0.86);
}

.toast-text {
  color: rgba(255, 255, 255, 0.96);
  font-size: 26rpx;
  font-weight: 600;
}
</style>
