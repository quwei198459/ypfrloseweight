<template>
  <view class="wm-card">
    <view class="wm-card__header">
      <text class="wm-card__title">{{ title }}</text>
      <text class="wm-card__total">{{ displayTotal }}</text>
    </view>
    <text class="wm-card__unit">{{ unitLabel }}</text>

    <view class="wm-chart">
      <view class="wm-chart__y">
        <text v-for="(lab, i) in yAxisLabels" :key="'y' + i" class="wm-chart__y-tick">{{ formatAxisTick(lab) }}</text>
      </view>
      <view class="wm-chart__plot">
        <!-- 横向网格（虚线） -->
        <view
          v-for="(g, i) in gridMetas"
          :key="'g' + i"
          class="wm-grid-line"
          :class="{ 'wm-grid-line--zero': g.isZeroAxis }"
          :style="{ top: g.pct + '%' }"
        />
        <!-- 推荐虚线 -->
        <view
          v-if="showGuideLine && guidePct != null"
          class="wm-guide-line"
          :style="{ top: guidePct + '%', borderColor: guideColor }"
        />
        <text
          v-if="showGuideLine && guideLabel"
          class="wm-guide-text"
          :style="{ top: guideTextTop + '%', color: guideColor }"
        >
          {{ guideLabel }}
        </text>

        <view class="wm-bars">
          <view v-for="(col, idx) in columnMetas" :key="'c' + idx" class="wm-bars__col">
            <view class="wm-bars__track">
              <text v-if="col.tip" class="wm-bar-tip" :style="col.tipStyle">{{ col.tip }}</text>
              <view class="wm-bar" :style="col.barStyle" />
            </view>
          </view>
        </view>
      </view>
    </view>

    <view class="wm-dates">
      <text v-for="(d, i) in dates" :key="'d' + i" class="wm-dates__t">{{ d }}</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { WeekMetricChartCardProps } from '../../types/weekMetricChart'

const props = withDefaults(defineProps<WeekMetricChartCardProps>(), {
  showGuideLine: false,
  guideValue: 0,
  guideLabel: '',
  barColor: '#E85D5D',
  guideColor: '#7CB342',
  mode: 'positive',
})

function parseNum(v: number | string): number {
  if (typeof v === 'number') return v
  const n = Number(String(v).replace(/,/g, ''))
  return Number.isFinite(n) ? n : 0
}

const numericAxis = computed(() => props.yAxisLabels.map(parseNum))

const yMin = computed(() => {
  const ns = numericAxis.value
  return ns.length ? Math.min(...ns) : 0
})

const yMax = computed(() => {
  const ns = numericAxis.value
  return ns.length ? Math.max(...ns) : 1
})

const span = computed(() => {
  const s = yMax.value - yMin.value
  return s === 0 ? 1 : s
})

function valueToPct(v: number): number {
  return ((yMax.value - v) / span.value) * 100
}

const displayTotal = computed(() => {
  if (typeof props.totalValue === 'number') {
    return `${props.totalValue}${props.totalSuffix}`
  }
  return `${props.totalValue}${props.totalSuffix}`
})

function formatAxisTick(lab: number | string): string {
  const n = parseNum(lab)
  if (Number.isInteger(n)) return String(n)
  return String(n)
}

function formatValueTip(v: number): string {
  if (Number.isInteger(v)) return String(v)
  return String(v)
}

const gridMetas = computed(() => {
  return props.yAxisLabels.map((lab) => {
    const n = parseNum(lab)
    const pct = valueToPct(n)
    const isZeroAxis = Math.abs(n) < 1e-9
    return { pct, isZeroAxis }
  })
})

const guidePct = computed(() => {
  if (!props.showGuideLine) return null
  return valueToPct(props.guideValue ?? 0)
})

const guideTextTop = computed(() => {
  const p = guidePct.value
  if (p == null) return 0
  return Math.max(0, p - 3)
})

function barBlockFor(val: number) {
  const yz = valueToPct(0)
  const color = props.barColor

  if (props.mode === 'empty' || Math.abs(val) < 1e-9) {
    return {
      barStyle: {
        top: `${yz}%`,
        height: '8rpx',
        marginTop: '-4rpx',
        backgroundColor: color,
        opacity: props.mode === 'empty' ? '0.55' : '0.85',
      },
      tip: '',
      tipStyle: {} as Record<string, string>,
    }
  }

  const yv = valueToPct(val)

  if (val > 0) {
    const top = Math.min(yv, yz)
    const h = Math.abs(yz - yv)
    return {
      barStyle: {
        top: `${top}%`,
        height: `${h}%`,
        backgroundColor: color,
      },
      tip: formatValueTip(val),
      tipStyle: {
        top: `${Math.max(0, top - 5)}%`,
      },
    }
  }

  const top = Math.min(yv, yz)
  const h = Math.abs(yv - yz)
  return {
    barStyle: {
      top: `${top}%`,
      height: `${h}%`,
      backgroundColor: color,
    },
    tip: formatValueTip(val),
    tipStyle: {
      top: `${Math.max(0, top - 5)}%`,
    },
  }
}

const columnMetas = computed(() => {
  return props.values.map((v) => {
    const b = barBlockFor(v)
    return {
      barStyle: b.barStyle,
      tip: b.tip,
      tipStyle: b.tipStyle,
    }
  })
})
</script>

<style lang="scss" scoped>
.wm-card {
  width: 100%;
  background: #ffffff;
  border-radius: 24rpx;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.07);
  padding: 28rpx 28rpx 24rpx;
  box-sizing: border-box;
}

.wm-card__header {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  gap: 16rpx;
}

.wm-card__title {
  flex: 1;
  min-width: 0;
  font-size: 28rpx;
  font-weight: 600;
  color: #333333;
}

.wm-card__total {
  font-size: 36rpx;
  font-weight: 600;
  color: #1a1a1a;
}

.wm-card__unit {
  display: block;
  margin-top: 8rpx;
  font-size: 22rpx;
  color: #999999;
}

.wm-chart {
  margin-top: 20rpx;
  display: flex;
  flex-direction: row;
  align-items: stretch;
}

.wm-chart__y {
  width: 72rpx;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  justify-content: space-between;
  padding-right: 8rpx;
  box-sizing: border-box;
  min-height: 320rpx;
}

.wm-chart__y-tick {
  font-size: 18rpx;
  color: #bbbbbb;
  line-height: 1;
}

.wm-chart__plot {
  position: relative;
  flex: 1;
  min-width: 0;
  height: 320rpx;
}

.wm-grid-line {
  position: absolute;
  left: 0;
  right: 0;
  z-index: 0;
  height: 0;
  border-top: 1rpx dashed #e6e6e6;
  transform: translateY(-50%);
  pointer-events: none;
}

.wm-grid-line--zero {
  border-top-style: solid;
  border-top-color: #d0d0d0;
  opacity: 0.95;
}

.wm-guide-line {
  position: absolute;
  left: 0;
  right: 0;
  z-index: 1;
  height: 0;
  border-top: 2rpx dashed currentColor;
  opacity: 0.85;
  transform: translateY(-50%);
  pointer-events: none;
}

.wm-guide-text {
  position: absolute;
  right: 0;
  z-index: 1;
  font-size: 20rpx;
  line-height: 1.2;
  transform: translateY(-50%);
  padding-left: 8rpx;
}

.wm-bars {
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  z-index: 2;
  display: flex;
  flex-direction: row;
  align-items: stretch;
  justify-content: space-between;
  gap: 8rpx;
  padding: 0 4rpx;
  box-sizing: border-box;
}

.wm-bars__col {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.wm-bars__track {
  position: relative;
  width: 100%;
  height: 100%;
}

.wm-bar {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  width: 70%;
  max-width: 36rpx;
  border-radius: 6rpx 6rpx 4rpx 4rpx;
}

.wm-bar-tip {
  position: absolute;
  left: 50%;
  transform: translate(-50%, -100%);
  font-size: 18rpx;
  color: #333333;
  white-space: nowrap;
}

.wm-dates {
  margin-top: 12rpx;
  margin-left: 72rpx;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  gap: 4rpx;
}

.wm-dates__t {
  flex: 1;
  text-align: center;
  font-size: 20rpx;
  color: #999999;
}
</style>
