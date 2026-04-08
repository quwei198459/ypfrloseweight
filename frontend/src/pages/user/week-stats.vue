<template>
  <scroll-view scroll-y enable-flex class="ws-page" :show-scrollbar="false">
    <view class="week-stats-hero">
      <view class="week-stats-hero__bg" />
      <view class="week-stats-hero__bg week-stats-hero__bg--dec" />
      <view class="week-stats-hero__row">
        <text class="week-stats-hero__date">{{ dateRange }}</text>
        <view class="week-stats-hero__panda">
          <text class="week-stats-hero__panda-emoji">🐼</text>
        </view>
      </view>
    </view>

    <view class="week-stats-card-list">
      <WeekMetricChartCard
        v-for="(card, i) in cards"
        :key="`${rangeKey}-${i}`"
        v-bind="card"
      />
    </view>

    <view class="ws-bottom-gap" />
  </scroll-view>
</template>

<script setup lang="ts">
import { onShow } from '@dcloudio/uni-app'
import { computed, ref } from 'vue'
import WeekMetricChartCard from '../../components/user/WeekMetricChartCard.vue'
import { weekStatsMockCards } from '../../constants/weekStatsMock'
import { fetchWeekStats } from '@/api/loseweight'
import type { WeekStatsCardDto, WeekStatsDto } from '@/api/types'
import type { WeekMetricChartCardProps } from '@/types/weekMetricChart'
import { formatRollingRangeLabel, getRolling7DaysRange } from '@/utils/rolling7Days'

/** 近 7 日：今天 + 之前 6 天（本地），供接口与展示 */
const startDate = ref('')
const endDate = ref('')
const dateRange = ref('')
const rangeKey = ref('')
const chartLabels = ref<string[]>([])
/** 与横轴 labels 长度一致时替换 mock */
const serverCards = ref<WeekStatsCardDto[] | null>(null)

function mapServerToProps(labels: string[], sc: WeekStatsCardDto[]): WeekMetricChartCardProps[] {
  return sc.map((raw) => {
    const anyCard = raw as any
    const axis =
      (anyCard.yAxisLabels as WeekMetricChartCardProps['yAxisLabels']) ??
      (anyCard.yaxisLabels as WeekMetricChartCardProps['yAxisLabels']) ??
      []

    return {
      title: raw.title,
      unitLabel: raw.unitLabel,
      totalValue: raw.totalValue,
      totalSuffix: raw.totalSuffix,
      dates: [...labels],
      values: [...raw.values],
      yAxisLabels: axis.length ? axis : (weekStatsMockCards[0].yAxisLabels as any),
      showGuideLine: raw.showGuideLine,
      guideValue: raw.guideValue,
      guideLabel: raw.guideLabel,
      barColor: raw.barColor,
      guideColor: raw.guideColor,
      mode: raw.mode,
    }
  })
}

const cards = computed((): WeekMetricChartCardProps[] => {
  const labels = chartLabels.value
  const sc = serverCards.value

  // 只要拿到了后端 cards，就直接用后端数据（优先保证观感与真实统计一致）
  if (sc && sc.length && labels.length === 7) {
    return mapServerToProps(labels, sc)
  }

  // 没有接口数据或出错时，保持原有 mock 行为
  if (!labels.length) return weekStatsMockCards
  return weekStatsMockCards.map((c) => ({ ...c, dates: [...labels] }))
})

function applyRollingRange() {
  const r = getRolling7DaysRange()
  startDate.value = r.startDate
  endDate.value = r.endDate
  chartLabels.value = r.chartDateLabels
  dateRange.value = formatRollingRangeLabel(r.startDate, r.endDate)
  rangeKey.value = `${r.startDate}_${r.endDate}`
}

onShow(() => {
  applyRollingRange()
  serverCards.value = null
  fetchWeekStats(startDate.value, endDate.value)
    .then((data: WeekStatsDto) => {
      if (data?.cards?.length) serverCards.value = data.cards
    })
    .catch(() => {
      /* 网络或未登录等：保留 mock */
    })
})
</script>

<style lang="scss" scoped>
.ws-page {
  min-height: 100vh;
  height: 100vh;
  background: #f6f6f6;
  box-sizing: border-box;
}

.week-stats-hero {
  position: relative;
  padding: 24rpx 32rpx 32rpx;
  box-sizing: border-box;
  overflow: hidden;
}

.week-stats-hero__bg {
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(180deg, #eaf6d4 0%, #d4e8b8 100%);
  z-index: 0;
}

.week-stats-hero__bg--dec {
  opacity: 0.35;
  background: radial-gradient(circle at 88% 18%, rgba(255, 255, 255, 0.72) 0%, transparent 52%),
    radial-gradient(circle at 8% 78%, rgba(255, 255, 255, 0.45) 0%, transparent 48%);
}

.week-stats-hero__row {
  position: relative;
  z-index: 1;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  gap: 16rpx;
}

.week-stats-hero__date {
  font-size: 30rpx;
  font-weight: 600;
  color: #333333;
}

.week-stats-hero__panda {
  width: 92rpx;
  height: 92rpx;
  border-radius: 46rpx;
  background: rgba(255, 255, 255, 0.78);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4rpx 10rpx rgba(0, 0, 0, 0.08);
}

.week-stats-hero__panda-emoji {
  font-size: 42rpx;
  line-height: 1;
}

.week-stats-card-list {
  padding: 0 32rpx 32rpx;
  display: flex;
  flex-direction: column;
  gap: 24rpx;
  box-sizing: border-box;
}

.ws-bottom-gap {
  height: calc(24rpx + env(safe-area-inset-bottom));
}
</style>
