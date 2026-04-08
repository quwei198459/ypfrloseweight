<template>
  <view class="card">
    <view class="budget-row">
      <view class="col">
        <text class="label">还可摄入</text>
        <text class="value big">{{ remainingCalories }}</text>
      </view>
      <view class="col">
        <text class="label">目标</text>
        <text class="value">{{ targetCalories }}</text>
      </view>
      <view class="col">
        <text class="label">已摄入</text>
        <text class="value">{{ intakeCalories }}</text>
      </view>
      <view class="col">
        <text class="label">运动消耗</text>
        <text class="value">{{ sportCalories }}</text>
      </view>
    </view>
    <text class="formula">{{ formula }}</text>
    <view class="macro-row">
      <view class="macro">
        <text class="macro-label">碳水</text>
        <view class="bar">
          <view class="fill" :style="carbFillStyle" />
        </view>
        <text class="macro-value">{{ carbsText }}</text>
      </view>
      <view class="macro">
        <text class="macro-label">脂肪</text>
        <view class="bar">
          <view class="fill" :style="fatFillStyle" />
        </view>
        <text class="macro-value">{{ fatText }}</text>
      </view>
      <view class="macro">
        <text class="macro-label">蛋白质</text>
        <view class="bar">
          <view class="fill" :style="proteinFillStyle" />
        </view>
        <text class="macro-value">{{ proteinText }}</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue'

type MacroVals = {
  carbsG: number
  fatG: number
  proteinG: number
  carbTargetG?: number
  fatTargetG?: number
  proteinTargetG?: number
}

const DEFAULT_CARB_T = 250
const DEFAULT_FAT_T = 60
const DEFAULT_PROTEIN_T = 90

/** 未超目标时的通道色，与历史设计稿一致 */
const BASE_CARB = '#f6b26b'
const BASE_FAT = '#ffd966'
const BASE_PROTEIN = '#9fd5b5'
const WARN = '#e6b84a'
const OVER = '#e06666'

const props = withDefaults(
  defineProps<{
    remainingCalories?: number
    targetCalories?: number
    intakeCalories?: number
    sportCalories?: number
    macros?: MacroVals | null
  }>(),
  {
    remainingCalories: 0,
    targetCalories: 0,
    intakeCalories: 0,
    sportCalories: 0,
    macros: () => ({
      carbsG: 0,
      fatG: 0,
      proteinG: 0,
      carbTargetG: DEFAULT_CARB_T,
      fatTargetG: DEFAULT_FAT_T,
      proteinTargetG: DEFAULT_PROTEIN_T,
    }),
  }
)

const remainingCalories = computed(() => Math.round(props.remainingCalories ?? 0))
const targetCalories = computed(() => Math.round(props.targetCalories ?? 0))
const intakeCalories = computed(() => Math.round(props.intakeCalories ?? 0))
const sportCalories = computed(() => Math.round(props.sportCalories ?? 0))

const formula = computed(
  () =>
    `${remainingCalories.value} = ${targetCalories.value} - ${intakeCalories.value} + ${sportCalories.value}`
)

function round0(v: number) {
  return Math.round(Number(v) || 0)
}

function targetOr(
  v: number | undefined,
  fallback: number
): number {
  const n = Number(v)
  return n > 0 && Number.isFinite(n) ? n : fallback
}

const carbTarget = computed(() =>
  targetOr(props.macros?.carbTargetG, DEFAULT_CARB_T)
)
const fatTarget = computed(() => targetOr(props.macros?.fatTargetG, DEFAULT_FAT_T))
const proteinTarget = computed(() =>
  targetOr(props.macros?.proteinTargetG, DEFAULT_PROTEIN_T)
)

const carbsText = computed(
  () => `${round0(props.macros?.carbsG ?? 0)} / ${round0(carbTarget.value)} g`
)
const fatText = computed(
  () => `${round0(props.macros?.fatG ?? 0)} / ${round0(fatTarget.value)} g`
)
const proteinText = computed(
  () => `${round0(props.macros?.proteinG ?? 0)} / ${round0(proteinTarget.value)} g`
)

function macroRatio(current: number, target: number): number {
  const t = Number(target)
  const c = Number(current)
  if (!Number.isFinite(t) || t <= 0) return 0
  if (!Number.isFinite(c) || c < 0) return 0
  return c / t
}

function macroWidthPercent(ratio: number): number {
  if (!Number.isFinite(ratio) || ratio < 0) return 0
  return Math.min(100, ratio * 100)
}

function macroBarColor(ratio: number, base: string): string {
  if (ratio >= 1) return OVER
  if (ratio >= 0.75) return WARN
  return base
}

const carbRatio = computed(() =>
  macroRatio(props.macros?.carbsG ?? 0, carbTarget.value)
)
const fatRatio = computed(() => macroRatio(props.macros?.fatG ?? 0, fatTarget.value))
const proteinRatio = computed(() =>
  macroRatio(props.macros?.proteinG ?? 0, proteinTarget.value)
)

const carbFillStyle = computed(() => ({
  width: `${macroWidthPercent(carbRatio.value)}%`,
  backgroundColor: macroBarColor(carbRatio.value, BASE_CARB),
}))
const fatFillStyle = computed(() => ({
  width: `${macroWidthPercent(fatRatio.value)}%`,
  backgroundColor: macroBarColor(fatRatio.value, BASE_FAT),
}))
const proteinFillStyle = computed(() => ({
  width: `${macroWidthPercent(proteinRatio.value)}%`,
  backgroundColor: macroBarColor(proteinRatio.value, BASE_PROTEIN),
}))
</script>

<style scoped lang="scss">
.card {
  width: 100%;
  border-radius: 20px;
  background: #ffffff;
  padding: 12px 16px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.budget-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.col {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.label {
  font-size: 11px;
  color: #777777;
}

.value {
  font-size: 14px;
  color: #222222;
}

.value.big {
  font-size: 18px;
  font-weight: 700;
}

.formula {
  font-size: 10px;
  color: #999999;
}

.macro-row {
  display: flex;
  justify-content: space-between;
  gap: 10px;
}

.macro {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.macro-label {
  font-size: 11px;
  color: #555555;
}

.bar {
  height: 6px;
  border-radius: 3px;
  background: #f0f0f0;
  overflow: hidden;
}

.fill {
  height: 100%;
  border-radius: 3px;
  min-width: 0;
}

.macro-value {
  font-size: 10px;
  color: #777777;
}
</style>
