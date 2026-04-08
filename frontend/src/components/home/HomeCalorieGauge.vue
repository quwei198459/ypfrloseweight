<template>
  <view class="home-calorie-gauge" :class="[`home-calorie-gauge--${status}`]">
    <view class="gauge-frame">
      <!-- 半圆环：仅显示上半圆弧，后续可接 canvas/SVG 插件替换本层 -->
      <view class="gauge-arc-mask">
        <view
          class="gauge-arc-ring"
          :class="{ 'gauge-arc-ring--gradient': gradientArc }"
          :style="gradientArc ? {} : arcRingStyle"
        />
      </view>
      <!-- 文案与数值置于弧线围成的视觉区域内，整体居中；两行独立热区 -->
      <view class="gauge-inner">
        <view
          class="gauge-help-entry"
          :class="{ 'gauge-help-entry--clickable': clickable }"
          @click.stop="handleHelpClick"
        >
          <text class="gauge-label">{{ label }}</text>
          <view class="gauge-help-icon-wrap" aria-hidden="true">
            <text class="gauge-help-icon-char">?</text>
          </view>
        </view>
        <view
          class="gauge-value-row"
          :class="{ 'gauge-value-row--clickable': clickable }"
          @click.stop="handleValueClick"
        >
          <text class="gauge-value-num">{{ formattedValue }}</text>
          <text v-if="unit" class="gauge-unit">{{ unit }}</text>
          <text v-if="showArrow" class="gauge-arrow-char">›</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue'

export type CalorieGaugeStatus = 'normal' | 'warning' | 'exceeded'

const props = withDefaults(
  defineProps<{
    /** 顶部说明，默认「还可吃」 */
    label?: string
    /** 当前数值（如剩余热量） */
    value?: number | string
    /** 可选单位 */
    unit?: string
    /** 满量程，后续接图表进度 / 后端比例用 */
    max?: number
    status?: CalorieGaugeStatus
    clickable?: boolean
    showArrow?: boolean
    /** 为 true 时使用多色渐变弧（还可吃/预算占比视觉），默认 false 保持首页纯色弧 */
    gradientArc?: boolean
  }>(),
  {
    label: '还可吃',
    value: 0,
    unit: '',
    max: 0,
    status: 'normal',
    clickable: true,
    showArrow: true,
    gradientArc: false,
  },
)

const emit = defineEmits<{
  /** 「还可吃 + 问号」：进入自定义基础代谢说明（二级页预留） */
  (e: 'clickHelp'): void
  /** 数字行：进入每日饮食记录 */
  (e: 'clickValue'): void
}>()

const ARC_COLORS: Record<CalorieGaugeStatus, string> = {
  normal: '#F39A66',
  warning: '#E8A838',
  exceeded: '#E85D5D',
}

const arcColor = computed(() => ARC_COLORS[props.status] ?? ARC_COLORS.normal)

const arcRingStyle = computed(() => {
  const style: Record<string, string> = { borderColor: arcColor.value }
  if (props.max > 0) {
    style['--gauge-max'] = String(props.max)
  }
  return style
})

const formattedValue = computed(() => {
  const v = props.value
  if (v === '' || v === null || v === undefined) return '0'
  return typeof v === 'number' && Number.isFinite(v) ? String(Math.round(v)) : String(v)
})

const handleHelpClick = () => {
  if (!props.clickable) return
  emit('clickHelp')
}

const handleValueClick = () => {
  if (!props.clickable) return
  emit('clickValue')
}
</script>

<style lang="scss" scoped>
.home-calorie-gauge {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  min-height: 132px;
}

.gauge-help-entry--clickable:active,
.gauge-value-row--clickable:active {
  opacity: 0.92;
}

/* 固定视口：半圆 + 内部文案一体 */
.gauge-frame {
  position: relative;
  width: 200px;
  height: 132px;
  flex-shrink: 0;
}

/* 半圆：裁切圆的上半部分，加粗弧线以包裹内部文案 */
.gauge-arc-mask {
  position: absolute;
  left: 50%;
  top: 0;
  transform: translateX(-50%);
  width: 200px;
  height: 102px;
  overflow: hidden;
  pointer-events: none;
}

.gauge-arc-ring {
  width: 200px;
  height: 200px;
  box-sizing: border-box;
  border-radius: 50%;
  border: 14px solid #f39a66;
  background: transparent;
}

/* 设计稿：左→右 橙 / 黄 / 绿，表示剩余占预算比例 */
.gauge-arc-ring--gradient {
  border: 14px solid transparent;
  background-color: transparent;
  background-image: linear-gradient(#ffffff, #ffffff),
    linear-gradient(90deg, #f39a66, #f6d675, #8bd28d);
  background-origin: border-box;
  background-clip: padding-box, border-box;
}

.gauge-inner {
  position: absolute;
  left: 50%;
  top: 56%;
  transform: translate(-50%, -50%);
  width: 176px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  pointer-events: auto;
}

.gauge-help-entry {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  flex-wrap: nowrap;
  gap: 5px;
}

.gauge-label {
  font-size: 11px;
  line-height: 1.2;
  color: #9a9a9a;
  text-align: center;
}

/* 轻量圆形问号，与设计稿一致 */
.gauge-help-icon-wrap {
  flex-shrink: 0;
  width: 14px;
  height: 14px;
  border-radius: 50%;
  border: 1px solid #dddddd;
  background-color: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
}

.gauge-help-icon-char {
  font-size: 10px;
  font-weight: 600;
  color: #9a9a9a;
  line-height: 1;
}

.gauge-value-row {
  margin-top: 12px;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  flex-wrap: nowrap;
}

.gauge-value-num {
  font-size: 22px;
  font-weight: 800;
  color: #222222;
  line-height: 1;
}

.gauge-unit {
  margin-left: 2px;
  font-size: 12px;
  color: #666666;
  line-height: 1;
}

/* 使用 Unicode 箭头字符，避免模板中的 > 被转义为 &gt; */
.gauge-arrow-char {
  margin-left: 2px;
  font-size: 20px;
  font-weight: 600;
  color: #222222;
  line-height: 1;
  transform: translateY(-1px);
}
</style>
