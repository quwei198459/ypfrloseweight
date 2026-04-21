<template>
  <view v-if="visible && food" class="overlay">
    <view class="mask" @click="emit('close')" />
    <view class="sheet">
      <view class="top">
        <image class="panda" src="/static/category/category-lunch-active.png" mode="aspectFit" />
        <view v-if="!hideMealBar" class="meal-trigger" @click="emit('toggle-meal-menu')">
          <text>{{ mealLabel }}</text>
          <text class="arrow">⌄</text>
        </view>
        <view v-else class="top-spacer" />
        <text class="close" @click="emit('close')">×</text>
      </view>

      <view v-if="!hideMealBar && mealMenuVisible" class="meal-menu">
        <view
          v-for="m in mealOptions"
          :key="m.value"
          class="meal-item"
          :class="{ active: mealType === m.value }"
          @click="emit('pick-meal', m.value)"
        >{{ m.label }}</view>
      </view>

      <view class="food-head">
        <image class="thumb" :src="thumbSrc" mode="aspectFill" @error="onThumbErr" />
        <view class="meta">
          <text class="name">{{ food.name }}</text>
          <text class="cal">{{ headlineKcalLine }}</text>
        </view>
        <view v-if="showGiTag" class="gi" :class="giClass" @click.stop="emit('go-gi-guide')">{{ giText }}</view>
      </view>

      <view class="nutrition">
        <view class="ring">
          <text class="ring-num">{{ centerKcal }}</text>
          <text class="ring-unit">Kcal</text>
        </view>
        <view class="macro">
          <view class="line"><text>碳水</text><text>{{ carbsG }}g</text><text class="pct">{{ carbPct }}%</text></view>
          <view class="line"><text>蛋白质</text><text>{{ proteinG }}g</text><text class="pct">{{ proteinPct }}%</text></view>
          <view class="line"><text>脂肪</text><text>{{ fatG }}g</text><text class="pct">{{ fatPct }}%</text></view>
        </view>
      </view>

      <text v-if="standardWeightG > 0 && inputMode === 'portion'" class="edible">
        可食部分：{{ standardWeightG }}g
      </text>

      <view class="qty-row">
        <view class="center">
          <text class="num">{{ quantityText }}</text>
          <view class="line-under" />
          <view class="unit-switch">
            <view
              class="unit-opt"
              :class="{ active: inputMode === 'gram' }"
              @click="emit('set-mode', 'gram')"
            >
              <text>克</text>
              <text v-if="inputMode === 'gram'" class="unit-arrow">▲</text>
            </view>
            <view
              class="unit-opt"
              :class="{ active: inputMode === 'portion' }"
              @click="emit('set-mode', 'portion')"
            >
              <text>{{ portionUnitLabel }}</text>
              <text v-if="inputMode === 'portion'" class="unit-arrow">▲</text>
            </view>
          </view>
        </view>
        <view class="estimate"><text>估重</text><text class="q">?</text></view>
      </view>

      <view class="keyboard">
        <view class="keys">
          <view v-for="k in keys" :key="k" class="k" @click="onKey(k)">{{ k }}</view>
          <view class="k" @click="onKey('.')">.</view>
          <view class="k k0" @click="onKey('0')">0</view>
        </view>
        <view class="actions">
          <view class="del" @click="emit('delete')">⌫</view>
          <view class="ok" @click.stop="emit('confirm')">确定</view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { FOOD_IMAGE_PLACEHOLDER } from '@/constants/foodImage'

const props = defineProps<{
  visible: boolean
  hideMealBar?: boolean
  mealMenuVisible: boolean
  mealType: string
  mealLabel: string
  quantityText: string
  /** 克 | 份(单位名) */
  inputMode: 'gram' | 'portion'
  portionUnitLabel: string
  centerKcal: number
  standardWeightG: number
  food: null | {
    id: string
    name: string
    calories: number
    caloriesText: string
    proteinG: number
    fatG: number
    carbsG: number
    giLevel?: string
    image?: string
  }
}>()

const thumbBroken = ref(false)
watch(
  () => props.food?.id,
  () => {
    thumbBroken.value = false
  }
)

const thumbSrc = computed(() => {
  if (thumbBroken.value) return FOOD_IMAGE_PLACEHOLDER
  const u = (props.food?.image || '').trim()
  return u || FOOD_IMAGE_PLACEHOLDER
})

function onThumbErr() {
  thumbBroken.value = true
}

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'toggle-meal-menu'): void
  (e: 'pick-meal', value: string): void
  (e: 'key', value: string): void
  (e: 'delete'): void
  (e: 'confirm'): void
  (e: 'go-gi-guide'): void
  (e: 'set-mode', mode: 'gram' | 'portion'): void
}>()

/** 与圆环 centerKcal、当前数量、克/份切换一致（避免写死「174 千卡/1碗」不刷新） */
const headlineKcalLine = computed(() => {
  const q = (props.quantityText || '').trim() || '1'
  const k = Math.max(0, Math.round(Number(props.centerKcal) || 0))
  if (props.inputMode === 'gram') {
    return `${k} 千卡 / ${q}克`
  }
  const u = props.portionUnitLabel || '份'
  return `${k} 千卡 / ${q}${u}`
})

const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
const mealOptions = [
  { value: 'breakfast', label: '早餐' },
  { value: 'lunch', label: '午餐' },
  { value: 'dinner', label: '晚餐' },
  { value: 'snack', label: '加餐' },
]
const proteinG = computed(() => (props.food?.proteinG ?? 0).toFixed(1))
const fatG = computed(() => (props.food?.fatG ?? 0).toFixed(1))
const carbsG = computed(() => (props.food?.carbsG ?? 0).toFixed(1))
const totalMacroKcal = computed(() => {
  const c = Number(carbsG.value) * 4
  const p = Number(proteinG.value) * 4
  const f = Number(fatG.value) * 9
  return c + p + f || 1
})
const carbPct = computed(() => Math.round((Number(carbsG.value) * 4 * 100) / totalMacroKcal.value))
const proteinPct = computed(() => Math.round((Number(proteinG.value) * 4 * 100) / totalMacroKcal.value))
const fatPct = computed(() => Math.max(0, 100 - carbPct.value - proteinPct.value))
const showGiTag = computed(() => {
  const lv = props.food?.giLevel
  return lv === 'high' || lv === 'medium' || lv === 'low'
})
const giText = computed(() => {
  if (props.food?.giLevel === 'high') return '高GI'
  if (props.food?.giLevel === 'medium') return '中GI'
  return '低GI'
})
const giClass = computed(() => {
  const lv = props.food?.giLevel
  if (lv === 'high') return 'gi--high'
  if (lv === 'medium') return 'gi--medium'
  return 'gi--low'
})
const onKey = (k: string) => emit('key', k)
</script>

<style scoped lang="scss">
.overlay { position: fixed; inset: 0; z-index: 45; }
.mask { position: absolute; inset: 0; background: rgba(0, 0, 0, 0.35); }
.sheet {
  position: absolute; left: 0; right: 0; bottom: 0; height: 82vh;
  background: #fff; border-radius: 20px 20px 0 0; border-top: 2px solid #2e2e2e;
  padding: 10px 14px; display: flex; flex-direction: column;
}
.top { display: flex; align-items: center; justify-content: space-between; gap: 8px; }
.panda { width: 34px; height: 34px; flex-shrink: 0; }
.top-spacer { flex: 1; }
.meal-trigger { display: flex; align-items: center; gap: 3px; font-size: 15px; }
.arrow { color: #666; }
.close { font-size: 28px; color: #8b8b8b; padding: 2px 10px; flex-shrink: 0; }
.meal-menu { width: 110px; border: 1px solid #e5e5e5; border-radius: 10px; margin-top: 6px; }
.meal-item { padding: 8px 12px; font-size: 13px; }
.meal-item.active { background: #f5f8ea; color: #8eaf57; font-weight: 700; }
.food-head { display: flex; align-items: flex-start; gap: 10px; margin-top: 8px; }
.thumb { width: 52px; height: 52px; border-radius: 10px; background: #f2f2f2; flex-shrink: 0; }
.meta { flex: 1; min-width: 0; display: flex; flex-direction: column; gap: 2px; }
.name { font-size: 16px; font-weight: 600; }
.cal { font-size: 12px; color: #7a7a7a; }
.gi {
  flex-shrink: 0;
  font-size: 11px;
  padding: 2px 8px;
  text-align: center;
  border-radius: 6px;
}
.gi--high {
  background: #ffebee;
  color: #c62828;
}
.gi--medium {
  background: #fff8e1;
  color: #e65100;
}
.gi--low {
  background: #e8f5e9;
  color: #5f8d45;
}
.nutrition { margin-top: 10px; display: flex; gap: 12px; }
.ring {
  width: 102px; height: 102px; border-radius: 51px; border: 8px solid #a5d6a7;
  display: flex; flex-direction: column; align-items: center; justify-content: center;
}
.ring-num { font-size: 20px; font-weight: 700; color: #33691e; }
.ring-unit { font-size: 10px; color: #689f38; }
.macro { flex: 1; display: flex; flex-direction: column; justify-content: center; gap: 8px; }
.line { display: grid; grid-template-columns: 48px 1fr 34px; align-items: center; font-size: 13px; color: #333; }
.pct { text-align: right; color: #666; }
.edible { margin-top: 8px; font-size: 12px; color: #ff9800; }
.qty-row { margin-top: 6px; display: flex; align-items: center; justify-content: space-between; }
.center { flex: 1; display: flex; flex-direction: column; align-items: center; }
.num { font-size: 44px; color: #8bc34a; line-height: 1; }
.line-under { width: 56px; height: 3px; border-radius: 2px; background: #8bc34a; margin: 4px 0; }
.unit-switch {
  display: flex;
  align-items: flex-end;
  justify-content: center;
  gap: 28px;
  margin-top: 4px;
}
.unit-opt {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2px;
  font-size: 13px;
  color: #9a9a9a;
}
.unit-opt.active {
  color: #6f9a3a;
  font-weight: 600;
}
.unit-arrow {
  font-size: 10px;
  color: #8bc34a;
  line-height: 1;
}
.estimate { width: 70px; display: flex; align-items: center; justify-content: flex-end; gap: 4px; font-size: 12px; color: #8bc34a; }
.q { width: 14px; height: 14px; border: 1px solid #8bc34a; border-radius: 7px; line-height: 14px; text-align: center; font-size: 10px; }
.keyboard { margin-top: 8px; display: flex; gap: 8px; height: 220px; flex-shrink: 0; }
.keys { flex: 1; display: grid; grid-template-columns: repeat(3, 1fr); gap: 6px; }
.k {
  background: #fafafa; border: 1px solid #ececec; border-radius: 10px;
  display: flex; align-items: center; justify-content: center; font-size: 22px;
}
.k0 { grid-column: span 2; }
.actions { width: 74px; display: flex; flex-direction: column; gap: 6px; }
.del { height: 64px; border: 1px solid #ececec; border-radius: 10px; display: flex; align-items: center; justify-content: center; }
.ok { flex: 1; border-radius: 10px; background: #bfd98a; color: #4b5b2d; display: flex; align-items: center; justify-content: center; font-size: 15px; font-weight: 600; }
</style>
