<template>
  <view v-if="visible" class="overlay">
    <view class="mask" @click="emit('close')" />
    <view class="sheet">
      <view class="header">
        <image class="panda-peek" src="/static/category/category-lunch-active.png" mode="aspectFit" />
        <view class="meal-anchor">
          <view class="meal-trigger" @click.stop="emit('toggle-meal-menu')">
            <text class="meal">{{ mealLabel }}</text>
            <text v-if="!mealMenuVisible" class="arrow">⌄</text>
          </view>
          <view v-if="mealMenuVisible" class="meal-menu">
            <view
              v-for="item in mealOptions"
              :key="item.value"
              class="meal-item"
              :class="{ active: item.value === mealType }"
              @click="emit('pick-meal', item.value)"
            >
              {{ item.label }}
            </view>
          </view>
        </view>
        <view class="header-spacer" />
        <text class="close" @click="emit('close')">×</text>
      </view>

      <scroll-view scroll-y class="list">
        <view v-for="item in items" :key="item.id" class="row">
          <image
            class="thumb"
            :src="thumbFor(item)"
            mode="aspectFill"
            @error="markThumbFail(item.id)"
          />
          <view class="mid">
            <text class="name">{{ item.name }}</text>
            <text class="meta">{{ item.caloriesText }}</text>
          </view>
          <text class="del" @click="emit('remove', item.id)">🗑</text>
        </view>
      </scroll-view>

      <view class="bottom">
        <view class="left">
          <image class="panda" src="/static/category/category-lunch-active.png" mode="aspectFit" />
          <view class="text-col">
            <text class="meal2">{{ mealLabel }}</text>
            <view class="summary-row">
              <text class="summary">共{{ items.length }}条记录，总计</text>
              <text class="kcal">{{ totalKcal }}千卡</text>
            </view>
          </view>
        </view>
        <button class="done" @click="emit('complete')">完成</button>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { FOOD_IMAGE_PLACEHOLDER } from '@/constants/foodImage'

const props = defineProps<{
  visible: boolean
  mealMenuVisible: boolean
  mealType: string
  mealLabel: string
  totalKcal: number
  items: Array<{ id: string; name: string; caloriesText: string; image?: string }>
}>()

const thumbFailed = ref<Record<string, boolean>>({})
watch(
  () => props.visible,
  (v) => {
    if (v) thumbFailed.value = {}
  }
)

function thumbFor(item: { id: string; image?: string }) {
  if (thumbFailed.value[item.id]) return FOOD_IMAGE_PLACEHOLDER
  const u = (item.image || '').trim()
  return u || FOOD_IMAGE_PLACEHOLDER
}

function markThumbFail(id: string) {
  thumbFailed.value = { ...thumbFailed.value, [id]: true }
}

const mealOptions = [
  { value: 'breakfast', label: '早餐' },
  { value: 'lunch', label: '午餐' },
  { value: 'dinner', label: '晚餐' },
  { value: 'snack', label: '加餐' },
]

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'toggle-meal-menu'): void
  (e: 'pick-meal', value: string): void
  (e: 'remove', id: string): void
  (e: 'complete'): void
}>()
</script>

<style scoped lang="scss">
.overlay { position: fixed; inset: 0; z-index: 40; }
.mask { position: absolute; inset: 0; background: rgba(0, 0, 0, 0.35); }
.sheet {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  height: 74vh;
  background: #fff;
  border-radius: 20px 20px 0 0;
  border-top: 2px solid #2e2e2e;
  padding: 8px 14px 10px;
  display: flex;
  flex-direction: column;
}
.header {
  display: flex;
  align-items: center;
  gap: 8px;
}
.panda-peek {
  width: 34px;
  height: 34px;
  flex-shrink: 0;
}
.header-spacer {
  flex: 1;
  min-width: 0;
}
.meal-anchor {
  position: relative;
  flex-shrink: 0;
}
.meal-trigger {
  display: flex;
  align-items: center;
  gap: 4px;
}
.meal { font-size: 16px; font-weight: 600; }
.arrow { font-size: 14px; color: #666; line-height: 1; }
.close { font-size: 28px; color: #8b8b8b; padding: 2px 6px; flex-shrink: 0; }
.meal-menu {
  position: absolute;
  top: 100%;
  left: 0;
  margin-top: 6px;
  width: 110px;
  border: 1px solid #e5e5e5;
  border-radius: 10px;
  background: #fff;
  padding: 4px 0;
  z-index: 2;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
}
.meal-item { font-size: 13px; padding: 8px 12px; }
.meal-item.active { color: #8eaf57; font-weight: 700; background: #f5f8ea; }
.list { flex: 1; min-height: 0; margin-top: 8px; }
.row {
  display: flex; align-items: center; gap: 10px;
  padding: 10px 2px; border-bottom: 1px solid #efefef;
}
.thumb { width: 44px; height: 44px; border-radius: 10px; background: #f2f2f2; }
.mid { flex: 1; min-width: 0; display: flex; flex-direction: column; gap: 2px; }
.name { font-size: 14px; color: #222; }
.meta { font-size: 12px; color: #757575; }
.del { width: 28px; text-align: center; font-size: 16px; }
.bottom {
  height: 72px; margin-top: 8px; border-top: 1px solid #efefef;
  display: flex; align-items: center; justify-content: space-between;
}
.left { display: flex; align-items: center; gap: 8px; }
.panda { width: 34px; height: 34px; }
.meal2 { font-size: 13px; font-weight: 600; color: #222; }
.summary-row { display: flex; align-items: baseline; gap: 3px; }
.summary { font-size: 11px; color: #777; }
.kcal { font-size: 13px; font-weight: 700; color: #8eaf57; }
.done {
  width: 90px; height: 38px; border-radius: 19px; border: 0;
  background: #bfd98a; color: #4b5b2d; font-size: 14px; font-weight: 600;
  line-height: 38px; padding: 0;
}
</style>
