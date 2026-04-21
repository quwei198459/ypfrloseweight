<template>
  <scroll-view scroll-y enable-flex class="wt-page" :show-scrollbar="false">
    <view class="wt-content">
      <!-- summaryCard -->
      <view class="wt-summary">
        <view class="wt-hero-wrap" aria-hidden="true">
          <image class="wt-hero-img" :src="wtHeroSrc" mode="aspectFill" />
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
              v-if="mock.targetWeight > 0 && mock.chart.yMax > mock.chart.yMin"
              class="wt-chart__target"
              :style="{ bottom: yBottomPercent(mock.targetWeight) + '%' }"
            />
            <view class="wt-chart__fill" />

            <view
              v-for="(_, segIdx) in mock.chart.points.slice(0, -1)"
              :key="'seg' + segIdx"
              class="wt-chart__seg"
              :style="segStyle(segIdx)"
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
            <text v-if="mock.chart.points.length" class="wt-chart__panda-emoji" :style="pandaEmojiStyle">🐼</text>
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
      :default-value="currentWeightModalDefault"
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
import { computed, reactive, ref } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import WeightEditModal from '../../components/user/WeightEditModal.vue'
import { createWeightTrendState } from '../../constants/weightTrendMock'
import { fetchCurrentUser } from '@/api/loseweight'
import { updateUserProfile } from '@/api/user'
import { addWeightRecord, fetchWeightRecords } from '@/api/weight'
import { resolveUserId, STORAGE_TOKEN } from '@/config/api'
import type { AppUserDto, UpdateProfilePayload, WeightRecordRow } from '@/api/types'
import wtHero from '@/static/user/weight-trend-hero.png'

const wtHeroSrc = wtHero
const mock = reactive(createWeightTrendState())

const showInitialWeightModal = ref(false)
const showCurrentWeightModal = ref(false)
const showTargetWeightModal = ref(false)
/** 底部「+记录体重」打开弹层时不预填；从「当前体重」行编辑时预填 */
const currentWeightModalEmptyDefault = ref(false)
const currentWeightModalDefault = computed(() =>
  currentWeightModalEmptyDefault.value ? '' : String(mock.currentWeight || '')
)

type ModalKind = 'initial' | 'current' | 'target'

function openModal(kind: ModalKind, opts?: { record?: boolean }) {
  showInitialWeightModal.value = false
  showCurrentWeightModal.value = false
  showTargetWeightModal.value = false
  if (kind === 'initial') showInitialWeightModal.value = true
  else if (kind === 'current') {
    currentWeightModalEmptyDefault.value = Boolean(opts?.record)
    showCurrentWeightModal.value = true
  } else showTargetWeightModal.value = true
}

function onRecordTap() {
  openModal('current', { record: true })
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
    applyUserToTrend(user)

    const records = await fetchWeightRecords(90)
    applyRecordsToTrend(records)
    if (!records.length) {
      buildFallbackChartFromProfile()
    }
  } catch {
    /* 未登录或网络失败时保留当前展示 */
  }
}

function applyUserToTrend(user: AppUserDto) {
  const initJin = jinFromKg(user.initialWeightKg)
  const currJin = jinFromKg(user.currentWeightKg)
  const targetJin = jinFromKg(user.targetWeightKg)

  if (initJin > 0) mock.initialWeight = initJin
  if (currJin > 0) mock.currentWeight = currJin
  if (targetJin > 0) mock.targetWeight = targetJin

  if (mock.initialWeight > 0 && mock.currentWeight > 0) {
    mock.totalLoss = Math.round((mock.initialWeight - mock.currentWeight) * 10) / 10
  }
}

function formatMd(iso: string): string {
  const t = (iso || '').trim().slice(0, 10)
  const m = /^(\d{4})-(\d{2})-(\d{2})$/.exec(t)
  if (!m) return t
  return `${m[2]}/${m[3]}`
}

function recordSubtext(lastIso: string): string {
  const t = (lastIso || '').trim().slice(0, 10)
  const m = /^(\d{4})-(\d{2})-(\d{2})$/.exec(t)
  if (!m) return '—'
  const d0 = new Date(`${m[1]}-${m[2]}-${m[3]}T12:00:00`)
  const d1 = new Date()
  d1.setHours(12, 0, 0, 0)
  const diff = Math.floor((d1.getTime() - d0.getTime()) / 86400000)
  if (diff <= 0) return '今日更新'
  return `${diff}天前记录`
}

function setChartYRange(values: number[]) {
  const finite = values.filter((x) => Number.isFinite(x) && x > 0)
  if (!finite.length) {
    mock.chart.yMin = 120
    mock.chart.yMax = 170
    mock.chart.yAxis = [170, 160, 150, 140, 130, 120]
    return
  }
  const lo = Math.min(...finite)
  const hi = Math.max(...finite)
  const pad = 8
  let yMin = Math.floor((lo - pad) / 5) * 5
  let yMax = Math.ceil((hi + pad) / 5) * 5
  if (yMax - yMin < 20) {
    yMax = yMin + 20
  }
  mock.chart.yMin = yMin
  mock.chart.yMax = yMax
  const ticks: number[] = []
  const step = yMax - yMin <= 35 ? 5 : 10
  for (let y = yMax; y >= yMin - 0.001; y -= step) {
    ticks.push(Math.round(y))
  }
  mock.chart.yAxis = ticks
}

function applyRecordsToTrend(records: WeightRecordRow[]) {
  if (!Array.isArray(records) || records.length === 0) {
    mock.currentWeightRecordText = '—'
    mock.chart.points = []
    mock.chart.xAxis = []
    return
  }
  const sorted = [...records].sort(
    (a, b) => new Date(a.recordDate).getTime() - new Date(b.recordDate).getTime()
  )
  const last = sorted[sorted.length - 1]
  const currJin = jinFromKg(last.weightKg)
  if (currJin > 0) {
    mock.currentWeight = currJin
  }
  if (mock.initialWeight > 0 && mock.currentWeight > 0) {
    mock.totalLoss = Math.round((mock.initialWeight - mock.currentWeight) * 10) / 10
  }
  mock.currentWeightRecordText = recordSubtext(last.recordDate)

  const maxPts = 14
  const slice = sorted.slice(-maxPts)
  mock.chart.points = slice.map((r) => jinFromKg(r.weightKg))
  mock.chart.xAxis = slice.map((r) => formatMd(r.recordDate))
  const vals = [...mock.chart.points]
  if (mock.targetWeight > 0) vals.push(mock.targetWeight)
  setChartYRange(vals)
}

/** 无称重记录时，用资料上的初始/当前体重画一条示意折线 */
function buildFallbackChartFromProfile() {
  if (mock.chart.points.length > 0) return
  const init = mock.initialWeight
  const curr = mock.currentWeight
  const tgt = mock.targetWeight
  if (init > 0 && curr > 0) {
    mock.chart.points = [init, curr]
    mock.chart.xAxis = ['起点', '现在']
    const vals = tgt > 0 ? [init, curr, tgt] : [init, curr]
    setChartYRange(vals)
  }
}

onShow(() => {
  void syncFromProfileAndWeights()
})

const plotW = 620
const plotH = 280
const dotR = 8

/** 当前图表纵轴：yMin 在底部、yMax 在顶部 */
function yBottomPercent(v: number) {
  const span = mock.chart.yMax - mock.chart.yMin
  if (span <= 0) return 50
  return ((v - mock.chart.yMin) / span) * 100
}

function dotXs(n: number): number[] {
  if (n <= 0) return []
  if (n === 1) return [Math.round(plotW / 2)]
  const left = 52
  const right = plotW - 52
  return Array.from({ length: n }, (_, i) => Math.round(left + ((right - left) * i) / (n - 1)))
}

const xsRpx = computed(() => dotXs(mock.chart.points.length))

function valBottom(v: number) {
  const span = mock.chart.yMax - mock.chart.yMin
  if (span <= 0) return plotH / 2 + dotR
  return ((v - mock.chart.yMin) / span) * plotH + dotR
}

function segStyle(i: number) {
  const xs = xsRpx.value
  if (xs.length < 2 || i < 0 || i >= mock.chart.points.length - 1) {
    return { display: 'none' }
  }
  const x1 = xs[i]!
  const x2 = xs[i + 1]!
  const v1 = mock.chart.points[i]!
  const v2 = mock.chart.points[i + 1]!
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
  const xs = xsRpx.value
  const x = xs[i] ?? plotW / 2
  return {
    left: x - dotR + 'rpx',
    bottom: valBottom(v) - dotR + 'rpx',
  }
}

function labelStyle(i: number, v: number) {
  const xs = xsRpx.value
  const x = xs[i] ?? plotW / 2
  const bottom = valBottom(v) + 14
  const left = x - 18
  return {
    left: left + 'rpx',
    bottom: bottom + 'rpx',
  }
}

function xPercent(i: number) {
  const n = mock.chart.xAxis.length
  if (n <= 1) return 50
  return 12 + (76 * i) / (n - 1)
}

const pandaEmojiStyle = computed(() => {
  const pts = mock.chart.points
  if (!pts.length) return { display: 'none' }
  const i = pts.length - 1
  const xs = xsRpx.value
  const x = xs[i] ?? plotW / 2
  const v = pts[i]!
  return {
    left: x - 18 + 'rpx',
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
    uni.showLoading({ title: '保存中', mask: true })
    const kg = Math.round((valJin / 2) * 100) / 100
    await updateProfilePartial({ initialWeightKg: kg })
    await syncFromProfileAndWeights()
    uni.hideLoading()
    uni.showToast({ title: '已保存', icon: 'success' })
  } catch (e: unknown) {
    uni.hideLoading()
    const msg = e instanceof Error ? e.message : '保存失败'
    uni.showToast({ title: msg, icon: 'none' })
  }
}

async function handleTargetWeightConfirm(valJin: number) {
  try {
    uni.showLoading({ title: '保存中', mask: true })
    const kg = Math.round((valJin / 2) * 100) / 100
    await updateProfilePartial({ targetWeightKg: kg })
    await syncFromProfileAndWeights()
    uni.hideLoading()
    uni.showToast({ title: '已保存', icon: 'success' })
  } catch (e: unknown) {
    uni.hideLoading()
    const msg = e instanceof Error ? e.message : '保存失败'
    uni.showToast({ title: msg, icon: 'none' })
  }
}

async function handleCurrentWeightConfirm(valJin: number) {
  try {
    uni.showLoading({ title: '保存中', mask: true })
    const kg = Math.round((valJin / 2) * 100) / 100
    const id = resolveUserId()
    await addWeightRecord(id, {
      recordDate: new Date().toISOString().slice(0, 10),
      weightKg: kg,
    })
    await syncFromProfileAndWeights()
    uni.hideLoading()
    uni.showToast({ title: '已记录', icon: 'success' })
  } catch (e: unknown) {
    uni.hideLoading()
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

.wt-hero-wrap {
  width: 100%;
  height: 160rpx;
  border-radius: 28rpx;
  overflow: hidden;
  margin-bottom: 12rpx;
  background: #f3f7ed;
}

.wt-hero-img {
  width: 100%;
  height: 100%;
  display: block;
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
