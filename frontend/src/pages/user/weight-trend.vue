<template>
  <scroll-view scroll-y enable-flex class="wt-page" :show-scrollbar="false">
    <view class="wt-content">
      <!-- summaryCard -->
      <view class="wt-summary">
        <view class="wt-panda-row" aria-hidden="true">
          <view class="wt-confetti wt-confetti--b" />
          <view class="wt-confetti wt-confetti--g" />
          <view class="wt-confetti wt-confetti--o" />
          <view class="wt-confetti wt-confetti--p" />
          <view class="wt-panda wt-panda--left">
            <view class="wt-panda-face" />
          </view>
          <view class="wt-panda wt-panda--mid">
            <view class="wt-panda-face wt-panda-face--mid" />
          </view>
          <view class="wt-panda wt-panda--right">
            <view class="wt-panda-face" />
          </view>
        </view>

        <view class="wt-total-loss">
          <text class="wt-total-loss__lbl">累计减重</text>
          <text class="wt-total-loss__val">{{ mock.totalLoss }}</text>
          <text class="wt-total-loss__unit">斤</text>
        </view>

        <view class="wt-stats-row">
          <view class="wt-stat-col" @tap="openModal('initial')">
            <text class="wt-stat-col__title">初始体重</text>
            <view class="wt-stat-col__val-row">
              <text class="wt-stat-col__val">{{ mock.initialWeight }}斤</text>
              <text class="wt-stat-col__ico">✎</text>
            </view>
          </view>
          <view class="wt-stat-col" @tap="openModal('current')">
            <text class="wt-stat-col__title">当前体重</text>
            <view class="wt-stat-col__val-row">
              <text class="wt-stat-col__val wt-stat-col__val--green">{{ mock.currentWeight }}斤</text>
              <text class="wt-stat-col__ico">✎</text>
            </view>
            <text class="wt-stat-col__sub">（{{ mock.currentWeightRecordText }}）</text>
          </view>
          <view class="wt-stat-col" @tap="openModal('target')">
            <text class="wt-stat-col__title">目标体重</text>
            <view class="wt-stat-col__val-row">
              <text class="wt-stat-col__val">{{ mock.targetWeight }}斤</text>
              <text class="wt-stat-col__ico">✎</text>
            </view>
          </view>
        </view>
      </view>

      <!-- weight-chart-card -->
      <view class="wt-chart-card">
        <view class="wt-chart-title-row">
          <text class="wt-chart-title">体重</text>
          <view class="wt-chart-title-line" />
        </view>
        <view class="wt-chart-legend">
          <text class="wt-chart-legend__txt">（斤） 目标：{{ mock.targetWeight }}斤</text>
          <view class="wt-chart-legend__dash">
            <view v-for="i in 4" :key="i" class="wt-chart-legend__dash-bit" />
          </view>
        </view>

        <view class="wt-chart">
          <view class="wt-chart__y-labels">
            <text
              v-for="y in mock.chart.yAxis"
              :key="y"
              class="wt-chart__y-txt"
              :style="{ bottom: yBottomPercent(y) + '%' }"
            >{{ y }}</text>
          </view>
          <view class="wt-chart__plot">
            <view
              v-for="y in mock.chart.yAxis"
              :key="'g' + y"
              class="wt-chart__grid-h"
              :style="{ bottom: yBottomPercent(y) + '%' }"
            />
            <view
              class="wt-chart__target"
              :style="{ bottom: yBottomPercent(154) + '%' }"
            />
            <view class="wt-chart__fill" />

            <view
              class="wt-chart__seg"
              :style="segStyle(0)"
            />
            <view
              class="wt-chart__seg"
              :style="segStyle(1)"
            />

            <view
              v-for="(pv, i) in mock.chart.points"
              :key="'p' + i"
              class="wt-chart__dot"
              :style="dotStyle(i, pv)"
            />
            <text
              v-for="(pv, i) in mock.chart.points"
              :key="'l' + i"
              class="wt-chart__pt-lbl"
              :style="labelStyle(i, pv)"
            >{{ pv }}</text>
            <text class="wt-chart__panda-emoji" :style="pandaEmojiStyle">🐼</text>
          </view>
          <view class="wt-chart__x-axis">
            <text
              v-for="(d, i) in mock.chart.xAxis"
              :key="d"
              class="wt-chart__x-txt"
              :style="{ left: xPercent(i) + '%' }"
            >{{ d }}</text>
          </view>
        </view>
      </view>

      <view class="wt-record-wrap">
        <view class="wt-record-btn" @tap="onRecordTap">
          <text class="wt-record-btn__txt">+记录体重</text>
        </view>
      </view>

      <view class="wt-bottom-gap" />
    </view>

    <WeightEditModal
      :show="showInitialWeightModal"
      title="初始体重"
      :default-value="String(mock.initialWeight)"
      @update:show="showInitialWeightModal = $event"
      @confirm="handleInitialWeightConfirm"
    />
    <WeightEditModal
      :show="showCurrentWeightModal"
      title="当前体重"
      default-value=""
      @update:show="showCurrentWeightModal = $event"
      @confirm="handleCurrentWeightConfirm"
    />
    <WeightEditModal
      :show="showTargetWeightModal"
      title="目标体重"
      :default-value="String(mock.targetWeight)"
      @update:show="showTargetWeightModal = $event"
      @confirm="handleTargetWeightConfirm"
    />
  </scroll-view>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import WeightEditModal from '../../components/user/WeightEditModal.vue'
import { weightTrendMock } from '../../constants/weightTrendMock'
import { fetchCurrentUser } from '@/api/loseweight'
import { updateUserProfile } from '@/api/user'
import { addWeightRecord, fetchWeightRecords } from '@/api/weight'
import { apiPath, resolveUserId, STORAGE_TOKEN } from '@/config/api'
import { httpGetAuth, httpPost, httpPostAuth } from '@/utils/http'
import type { AppUserDto, UpdateProfilePayload } from '@/api/types'

const mock = weightTrendMock

const showInitialWeightModal = ref(false)
const showCurrentWeightModal = ref(false)
const showTargetWeightModal = ref(false)

type ModalKind = 'initial' | 'current' | 'target'

function openModal(kind: ModalKind) {
  showInitialWeightModal.value = false
  showCurrentWeightModal.value = false
  showTargetWeightModal.value = false
  if (kind === 'initial') showInitialWeightModal.value = true
  else if (kind === 'current') showCurrentWeightModal.value = true
  else showTargetWeightModal.value = true
}

function onRecordTap() {
  // 复用“当前体重”弹层逻辑
  openModal('current')
}

function jinFromKg(kg: number | null | undefined): number {
  if (kg == null) return 0
  const n = Number(kg)
  if (!Number.isFinite(n)) return 0
  return Math.round(n * 2 * 10) / 10
}

async function syncFromProfileAndWeights() {
  try {
    const user = await fetchCurrentUser()
    applyUserToMock(user)

    const id = resolveUserId()
    const records = await fetchWeightRecords(90)
    applyRecordsToMock(records)
  } catch {
    // 接口失败时保持原有 mock，不影响样式展示
  }
}

function applyUserToMock(user: AppUserDto) {
  const initJin = jinFromKg(user.initialWeightKg)
  const currJin = jinFromKg(user.currentWeightKg)
  const targetJin = jinFromKg(user.targetWeightKg)

  if (initJin > 0) {
    mock.initialWeight = initJin
  }
  if (currJin > 0) {
    mock.currentWeight = currJin
  }
  if (targetJin > 0) {
    mock.targetWeight = targetJin
  }

  if (initJin > 0 && currJin > 0) {
    mock.totalLoss = Math.round((initJin - currJin) * 10) / 10
  }
}

function applyRecordsToMock(records: { recordDate: string; weightKg: number }[]) {
  if (!Array.isArray(records) || records.length === 0) return
  const sorted = [...records].sort(
    (a, b) => new Date(a.recordDate).getTime() - new Date(b.recordDate).getTime()
  )
  const last = sorted[sorted.length - 1]
  const first = sorted[0]

  const currJin = jinFromKg(last.weightKg)
  const initJin = jinFromKg(first.weightKg)

  if (currJin > 0) {
    mock.currentWeight = currJin
  }
  if (initJin > 0) {
    mock.initialWeight = initJin
  }
  if (initJin > 0 && currJin > 0) {
    mock.totalLoss = Math.round((initJin - currJin) * 10) / 10
  }

  // 仅用最新 3 条填充折线点，保持现有视觉布局
  const last3 = sorted.slice(-3)
  if (last3.length > 0) {
    const pts = last3.map((r) => jinFromKg(r.weightKg))
    while (pts.length < mock.chart.points.length) {
      pts.unshift(mock.chart.points[0])
    }
    mock.chart.points = pts.slice(-mock.chart.points.length)
  }
}

onShow(() => {
  void syncFromProfileAndWeights()
})

/** 体重 v∈[120,170] 在纵轴上的 bottom 百分比（0=底 120，100=顶 170） */
function yBottomPercent(v: number) {
  return ((v - 120) / 50) * 100
}

const plotW = 620
const plotH = 280
const dotR = 8

const xs = [62, 310, 558]

function valBottom(v: number) {
  return ((v - 120) / 50) * plotH + dotR
}

function segStyle(i: number) {
  const x1 = xs[i]
  const x2 = xs[i + 1]
  const v1 = mock.chart.points[i]
  const v2 = mock.chart.points[i + 1]
  const y1 = valBottom(v1)
  const y2 = valBottom(v2)
  const dx = x2 - x1
  const dy = y2 - y1
  const len = Math.sqrt(dx * dx + dy * dy)
  const angle = (Math.atan2(-dy, dx) * 180) / Math.PI
  return {
    left: x1 + 'rpx',
    bottom: y1 + 'rpx',
    width: len + 'rpx',
    transform: `rotate(${angle}deg)`,
    transformOrigin: '0 50%',
  }
}

function dotStyle(i: number, v: number) {
  return {
    left: xs[i] - dotR + 'rpx',
    bottom: valBottom(v) - dotR + 'rpx',
  }
}

function labelStyle(i: number, v: number) {
  const bottom = valBottom(v) + 14
  const left = xs[i] - 18
  return {
    left: left + 'rpx',
    bottom: bottom + 'rpx',
  }
}

function xPercent(i: number) {
  const pct = [12, 50, 88][i] ?? 50
  return pct
}

const pandaEmojiStyle = computed(() => {
  const i = 2
  const v = mock.chart.points[2]
  return {
    left: xs[i] - 18 + 'rpx',
    bottom: valBottom(v) - 8 + 'rpx',
  }
})

async function updateProfilePartial(payload: UpdateProfilePayload) {
  const token = uni.getStorageSync(STORAGE_TOKEN) as string | undefined
  if (!token) {
    uni.showToast({ title: '请先登录', icon: 'none' })
    throw new Error('请先登录')
  }
  await updateUserProfile(token, payload)
}

async function handleInitialWeightConfirm(valJin: number) {
  try {
    const kg = Math.round((valJin / 2) * 100) / 100
    await updateProfilePartial({ initialWeightKg: kg })
    await syncFromProfileAndWeights()
  } catch (e: unknown) {
    const msg = e instanceof Error ? e.message : '保存失败'
    uni.showToast({ title: msg, icon: 'none' })
  }
}

async function handleTargetWeightConfirm(valJin: number) {
  try {
    const kg = Math.round((valJin / 2) * 100) / 100
    await updateProfilePartial({ targetWeightKg: kg })
    await syncFromProfileAndWeights()
  } catch (e: unknown) {
    const msg = e instanceof Error ? e.message : '保存失败'
    uni.showToast({ title: msg, icon: 'none' })
  }
}

async function handleCurrentWeightConfirm(valJin: number) {
  try {
    const kg = Math.round((valJin / 2) * 100) / 100
    const id = resolveUserId()
    await addWeightRecord(id, {
      recordDate: new Date().toISOString().slice(0, 10),
      weightKg: kg,
    })
    await syncFromProfileAndWeights()
  } catch (e: unknown) {
    const msg = e instanceof Error ? e.message : '记录失败'
    uni.showToast({ title: msg, icon: 'none' })
  }
}
</script>

<style lang="scss" scoped>
$wt-bg: #efefef;
$wt-green: #b8d67a;
$wt-green-dark: #9ebc6e;
$wt-fill: rgba(197, 217, 155, 0.35);

.wt-page {
  min-height: 100vh;
  height: 100vh;
  background: $wt-bg;
  box-sizing: border-box;
}

.wt-content {
  padding: 24rpx 28rpx 0;
  box-sizing: border-box;
}

.wt-summary {
  background: #ffffff;
  border-radius: 44rpx;
  border: 3rpx solid $wt-green;
  padding: 20rpx 28rpx 28rpx;
  box-sizing: border-box;
}

.wt-panda-row {
  position: relative;
  height: 88rpx;
  margin-bottom: 8rpx;
}

.wt-confetti {
  position: absolute;
  border-radius: 2rpx;
}

.wt-confetti--b {
  width: 10rpx;
  height: 14rpx;
  background: #6bb3ff;
  left: 36rpx;
  top: 16rpx;
}

.wt-confetti--g {
  width: 8rpx;
  height: 12rpx;
  background: #9fd89f;
  left: 52rpx;
  top: 12rpx;
}

.wt-confetti--o {
  width: 12rpx;
  height: 8rpx;
  background: #ffb347;
  right: 48rpx;
  top: 18rpx;
}

.wt-confetti--p {
  width: 8rpx;
  height: 12rpx;
  background: #e878d0;
  right: 28rpx;
  top: 10rpx;
}

.wt-panda {
  position: absolute;
  bottom: 0;
  display: flex;
  align-items: flex-end;
  justify-content: center;
}

.wt-panda--left {
  left: 64rpx;
  width: 72rpx;
  height: 72rpx;
}

.wt-panda--mid {
  left: 50%;
  margin-left: -42rpx;
  width: 84rpx;
  height: 84rpx;
}

.wt-panda--right {
  right: 64rpx;
  left: auto;
  width: 72rpx;
  height: 72rpx;
}

.wt-panda-face {
  width: 64rpx;
  height: 54rpx;
  border-radius: 50%;
  background: #ffffff;
  border: 3rpx solid #9e9e9e;
  position: relative;
}

.wt-panda-face--mid {
  width: 72rpx;
  height: 60rpx;
}

.wt-panda-face::before,
.wt-panda-face::after {
  content: '';
  position: absolute;
  width: 20rpx;
  height: 22rpx;
  background: #1a1a1a;
  border-radius: 50%;
  top: -6rpx;
}

.wt-panda-face::before {
  left: -4rpx;
}

.wt-panda-face::after {
  right: -4rpx;
}

.wt-total-loss {
  width: 336rpx;
  height: 336rpx;
  margin: 0 auto 20rpx;
  border-radius: 50%;
  border: 3rpx solid $wt-green-dark;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8rpx;
  box-sizing: border-box;
}

.wt-total-loss__lbl {
  font-size: 24rpx;
  color: #888888;
}

.wt-total-loss__val {
  font-size: 72rpx;
  font-weight: 600;
  color: #e85c5c;
  line-height: 1;
}

.wt-total-loss__unit {
  font-size: 26rpx;
  color: #888888;
}

.wt-stats-row {
  display: flex;
  flex-direction: row;
  gap: 20rpx;
  align-items: flex-start;
  justify-content: space-between;
}

.wt-stat-col {
  flex: 1 1 0;
  min-width: 0;
  display: flex;
  flex-direction: column;
  align-items: flex-center;
  gap: 10rpx;
  text-align: center;
}

.wt-stat-col__title {
  font-size: 22rpx;
  color: #666666;
  line-height: 1.3;
}

.wt-stat-col__val-row {
  flex-direction: row;
  align-items: center;
  gap: 8rpx;
}

.wt-stat-col__val {
  font-size: 30rpx;
  font-weight: 600;
  color: #1a1a1a;
}

.wt-stat-col__val--green {
  color: #8fb85c;
}

.wt-stat-col__ico {
  font-size: 26rpx;
  color: #333333;
  line-height: 1;
}

.wt-stat-col__sub {
  font-size: 20rpx;
  color: #999999;
  line-height: 1.35;
}

.wt-chart-card {
  margin-top: 24rpx;
  background: #ffffff;
  border-radius: 44rpx;
  border: 3rpx solid $wt-green;
  padding: 24rpx 24rpx 28rpx;
  box-sizing: border-box;
}

.wt-chart-title-row {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 10rpx;
  margin-bottom: 16rpx;
}

.wt-chart-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #1a1a1a;
}

.wt-chart-title-line {
  width: 96rpx;
  height: 12rpx;
  border-radius: 6rpx;
  background: #c5d99b;
}

.wt-chart-legend {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 16rpx;
  margin-bottom: 12rpx;
}

.wt-chart-legend__txt {
  font-size: 22rpx;
  color: #666666;
}

.wt-chart-legend__dash {
  display: flex;
  flex-direction: row;
  gap: 8rpx;
  align-items: center;
}

.wt-chart-legend__dash-bit {
  width: 14rpx;
  height: 4rpx;
  background: #7cb342;
  border-radius: 2rpx;
}

.wt-chart {
  position: relative;
  padding-left: 56rpx;
  min-height: 360rpx;
}

.wt-chart__y-labels {
  position: absolute;
  left: 0;
  top: 16rpx;
  width: 48rpx;
  height: 280rpx;
}

.wt-chart__y-txt {
  position: absolute;
  left: 0;
  transform: translateY(50%);
  font-size: 18rpx;
  color: #9aa4b2;
  line-height: 1;
}

.wt-chart__plot {
  position: relative;
  height: 280rpx;
  margin-top: 16rpx;
  margin-bottom: 36rpx;
}

.wt-chart__grid-h {
  position: absolute;
  left: 0;
  right: 0;
  height: 1rpx;
  background: #dde3ea;
  transform: translateY(50%);
}

.wt-chart__target {
  position: absolute;
  left: 0;
  right: 0;
  height: 0;
  border-top: 2rpx dashed #7cb342;
  transform: translateY(50%);
  z-index: 2;
}

.wt-chart__fill {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 92%;
  background: linear-gradient(
    168deg,
    $wt-fill 0%,
    rgba(197, 217, 155, 0.12) 55%,
    transparent 78%
  );
  pointer-events: none;
  z-index: 0;
}

.wt-chart__seg {
  position: absolute;
  height: 4rpx;
  background: #1a1a1a;
  transform-origin: 0 50%;
  z-index: 3;
}

.wt-chart__dot {
  position: absolute;
  width: 16rpx;
  height: 16rpx;
  border-radius: 50%;
  background: #7cb342;
  z-index: 4;
}

.wt-chart__pt-lbl {
  position: absolute;
  font-size: 18rpx;
  color: #333333;
  z-index: 4;
}

.wt-chart__panda-emoji {
  position: absolute;
  font-size: 36rpx;
  line-height: 1;
  z-index: 5;
}

.wt-chart__x-axis {
  position: relative;
  height: 32rpx;
  margin-top: -24rpx;
}

.wt-chart__x-txt {
  position: absolute;
  transform: translateX(-50%);
  font-size: 18rpx;
  color: #666666;
}

.wt-record-wrap {
  margin-top: 32rpx;
  padding-bottom: 8rpx;
}

.wt-record-btn {
  width: 100%;
  height: 104rpx;
  border-radius: 52rpx;
  background: #c5d99b;
  display: flex;
  align-items: center;
  justify-content: center;
}

.wt-record-btn__txt {
  font-size: 32rpx;
  font-weight: 600;
  color: #1a1a1a;
}

.wt-bottom-gap {
  height: calc(48rpx + env(safe-area-inset-bottom));
}
</style>
