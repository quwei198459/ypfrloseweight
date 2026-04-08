<template>
  <view v-if="visible && food" class="overlay">
    <view class="mask" @click="emit('close')" />
    <view class="sheet">
      <view class="top">
        <image class="panda" src="/static/category/category-lunch-active.png" mode="aspectFit" />
        <view class="meal-trigger" @click="emit('toggle-meal-menu')">
          <text>{{ mealLabel }}</text>
          <text class="arrow">⌄</text>
        </view>
        <text class="close" @click="emit('close')">×</text>
      </view>

      <view v-if="mealMenuVisible" class="meal-menu">
        <view
          v-for="m in mealOptions"
          :key="m.value"
          class="meal-item"
          :class="{ active: mealType === m.value }"
          @click="emit('pick-meal', m.value)"
        >{{ m.label }}</view>
      </view>

      <view class="food-head">
        <image class="thumb" :src="food.image || '/static/category/category-snack.png'" mode="aspectFill" />
        <view class="meta">
          <text class="name">{{ food.name }}</text>
          <text class="cal">{{ food.caloriesText }}</text>
          <view class="gi" @click="emit('go-gi-guide')">{{ giText }}</view>
        </view>
      </view>

      <view class="nutrition">
        <view class="ring">
          <text class="ring-num">{{ food.calories }}</text>
          <text class="ring-unit">Kcal</text>
        </view>
        <view class="macro">
          <view class="line"><text>碳水</text><text>{{ carbsG }}g</text><text class="pct">{{ carbPct }}%</text></view>
          <view class="line"><text>蛋白质</text><text>{{ proteinG }}g</text><text class="pct">{{ proteinPct }}%</text></view>
          <view class="line"><text>脂肪</text><text>{{ fatG }}g</text><text class="pct">{{ fatPct }}%</text></view>
        </view>
      </view>

      <text class="edible">可食部分：300g</text>

      <view class="qty-row">
        <view class="center">
          <text class="num">{{ quantityText }}</text>
          <view class="line-under" />
          <view class="unit-row"><text>克</text><text class="big-unit">大份</text></view>
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
          <view class="ok" @click="emit('confirm')">确定</view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  visible: boolean
  mealMenuVisible: boolean
  mealType: string
  mealLabel: string
  quantityText: string
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

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'toggle-meal-menu'): void
  (e: 'pick-meal', value: string): void
  (e: 'key', value: string): void
  (e: 'delete'): void
  (e: 'confirm'): void
  (e: 'go-gi-guide'): void
}>()

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
const giText = computed(() => {
  if (props.food?.giLevel === 'high') return '高GI'
  if (props.food?.giLevel === 'medium') return '中GI'
  return '低GI'
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
.top { display: flex; align-items: center; justify-content: space-between; }
.panda { width: 34px; height: 34px; }
.meal-trigger { display: flex; align-items: center; gap: 3px; margin-left: -80px; font-size: 15px; }
.arrow { color: #666; }
.close { font-size: 28px; color: #8b8b8b; padding: 2px 10px; }
.meal-menu { width: 110px; border: 1px solid #e5e5e5; border-radius: 10px; margin-top: 6px; }
.meal-item { padding: 8px 12px; font-size: 13px; }
.meal-item.active { background: #f5f8ea; color: #8eaf57; font-weight: 700; }
.food-head { display: flex; align-items: center; gap: 10px; margin-top: 8px; }
.thumb { width: 52px; height: 52px; border-radius: 10px; background: #f2f2f2; }
.meta { display: flex; flex-direction: column; gap: 2px; }
.name { font-size: 16px; font-weight: 600; }
.cal { font-size: 12px; color: #7a7a7a; }
.gi { margin-top: 2px; font-size: 11px; width: 44px; text-align: center; border-radius: 6px; background: #fbeaea; color: #cd7070; }
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
.unit-row { width: 92px; display: flex; justify-content: space-between; font-size: 12px; color: #6f7f54; }
.big-unit { font-size: 11px; }
.estimate { width: 70px; display: flex; align-items: center; justify-content: flex-end; gap: 4px; font-size: 12px; color: #8bc34a; }
.q { width: 14px; height: 14px; border: 1px solid #8bc34a; border-radius: 7px; line-height: 14px; text-align: center; font-size: 10px; }
.keyboard { margin-top: 8px; display: flex; gap: 8px; height: 220px; }
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

