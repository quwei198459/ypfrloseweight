<template>
  <view class="page">
    <view class="hero-bg" />
    <view class="search-row">
      <view class="search-box">
        <text class="search-icon">🔍</text>
        <text class="search-placeholder">海量食物库搜索</text>
      </view>
      <view class="custom-add" @click="customVisible = true">＋</view>
    </view>

    <view class="content" :class="{ 'has-bottom': selectedRows.length > 0 }">
      <scroll-view scroll-y class="sidebar-scroll" :show-scrollbar="false">
        <view
          v-for="c in categories"
          :key="c.code"
          class="cat"
          :class="{ active: c.code === category }"
          @click="category = c.code"
        >
          <text>{{ c.name }}</text>
          <view v-if="c.code === category" class="cat-underline" />
        </view>
      </scroll-view>

      <scroll-view scroll-y class="list" :show-scrollbar="false">
        <view v-for="f in filteredFoods" :key="f.id" class="food-row">
          <image class="thumb" :src="f.image || '/static/category/category-snack.png'" mode="aspectFill" />
          <view class="meta">
            <text class="name">{{ f.name }}</text>
            <text class="sub">{{ f.caloriesText }}</text>
          </view>
          <view
            class="row-action"
            :class="{ selected: selectedIds.includes(f.id) }"
            @click.stop="toggleSelect(f.id)"
          >
            {{ selectedIds.includes(f.id) ? '✓' : '+' }}
          </view>
        </view>
      </scroll-view>
    </view>

    <view v-if="selectedRows.length > 0" class="bottom-selected">
      <view class="left">
        <image class="panda" src="/static/category/category-lunch-active.png" mode="aspectFit" />
        <view class="text-col">
          <text class="meal">{{ mealLabel }}</text>
          <view class="summary-row">
            <text class="summary">共{{ selectedRows.length }}条记录，总计</text>
            <text class="kcal">{{ selectedKcal }}千卡</text>
          </view>
        </view>
      </view>
      <view class="done-btn">完成</view>
    </view>

    <CustomFoodPopup
      v-model:visible="customVisible"
      @cancel="customVisible = false"
      @confirm="handleCustomConfirm"
    />
  </view>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import CustomFoodPopup from '@/components/CustomFoodPopup.vue'

type FoodItem = {
  id: string
  category: string
  name: string
  calories: number
  caloriesText: string
  image?: string
}

const categories = [
  { code: 'common', name: '常用' },
  { code: 'fruit', name: '水果' },
  { code: 'grain', name: '主食' },
  { code: 'protein', name: '蛋白' },
]
const allFoods = ref<FoodItem[]>([
  { id: 'f1', category: 'fruit', name: '桔子', calories: 72, caloriesText: '72千卡/1个' },
  { id: 'f2', category: 'grain', name: '米饭', calories: 300, caloriesText: '300千卡/1大份' },
  { id: 'f3', category: 'protein', name: '鸡胸肉', calories: 132, caloriesText: '132千卡/100g' },
])

const category = ref('common')
const selectedIds = ref<string[]>([])
const mealType = ref<'breakfast' | 'lunch' | 'dinner' | 'snack'>('lunch')
const customVisible = ref(false)

const filteredFoods = computed(() =>
  category.value === 'common' ? allFoods.value : allFoods.value.filter((f) => f.category === category.value),
)
const selectedRows = computed(() => allFoods.value.filter((f) => selectedIds.value.includes(f.id)))
const selectedKcal = computed(() => selectedRows.value.reduce((sum, i) => sum + i.calories, 0))
const mealLabel = computed(() => {
  if (mealType.value === 'breakfast') return '早餐'
  if (mealType.value === 'dinner') return '晚餐'
  if (mealType.value === 'snack') return '加餐'
  return '午餐'
})

onLoad((query) => {
  const fromMeal = String(query?.mealType || 'lunch')
  if (fromMeal === 'breakfast' || fromMeal === 'lunch' || fromMeal === 'dinner' || fromMeal === 'snack') {
    mealType.value = fromMeal
  }
})

function toggleSelect(id: string) {
  const idx = selectedIds.value.indexOf(id)
  if (idx >= 0) selectedIds.value.splice(idx, 1)
  else selectedIds.value.push(id)
}

function handleCustomConfirm(payload: { name: string; weight: string; calories: string }) {
  const name = payload.name.trim()
  const calories = Number(payload.calories)
  const weight = Number(payload.weight)
  if (!name || !Number.isFinite(calories) || calories <= 0 || !Number.isFinite(weight) || weight <= 0) {
    uni.showToast({ title: '请填写有效食物信息', icon: 'none' })
    return
  }
  allFoods.value.unshift({
    id: `custom-${Date.now()}`,
    category: 'common',
    name,
    calories: Math.round(calories),
    caloriesText: `${Math.round(calories)}千卡/${Math.round(weight)}g`,
  })
  customVisible.value = false
  category.value = 'common'
  uni.showToast({ title: '已添加自定义食物', icon: 'none' })
}
</script>

<style scoped lang="scss">
.page {
  height: 100vh;
  background: #f7fbf7;
  position: relative;
  overflow: hidden;
}
.hero-bg {
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  height: 188px;
  background: #bfd9a3;
  border-radius: 0 0 24px 24px;
  z-index: 0;
}
.search-row {
  position: relative;
  z-index: 2;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 6px 16px 12px;
  box-sizing: border-box;
}
.search-box {
  flex: 1;
  height: 38px;
  border-radius: 19px;
  background: #fff;
  padding: 0 14px;
  display: flex;
  align-items: center;
  gap: 6px;
}
.search-icon {
  font-size: 13px;
  color: #8f8f8f;
}
.search-placeholder {
  font-size: 13px;
  color: #9a9a9a;
}
.custom-add {
  width: 34px;
  height: 34px;
  border-radius: 17px;
  background: #eef3df;
  border: 1px solid #d4dfb8;
  text-align: center;
  line-height: 34px;
  color: #7f9858;
  font-size: 20px;
  font-weight: 600;
}
.content {
  position: relative;
  z-index: 1;
  margin: -18px 16px 0;
  height: calc(100vh - 128px);
  border-radius: 22px;
  background: #fff;
  border: 1px solid #e0ead2;
  padding: 10px;
  box-sizing: border-box;
  display: flex;
  gap: 8px;
  align-items: stretch;
}
.content.has-bottom {
  height: calc(100vh - 212px);
}
.sidebar-scroll {
  width: 78px;
  flex-shrink: 0;
  min-height: 0;
  height: 100%;
  border-radius: 16px;
  background: #f6f8f0;
  padding: 10px 8px;
  box-sizing: border-box;
}
.cat {
  font-size: 12px;
  color: #8a8a8a;
  padding: 8px 0;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 4px;
}
.cat.active {
  color: #222;
  font-weight: 600;
}
.cat-underline {
  width: 22px;
  height: 3px;
  border-radius: 2px;
  background: #c5dd97;
}
.list {
  flex: 1;
  min-height: 0;
  height: 100%;
}
.food-row {
  display: flex;
  align-items: center;
  gap: 10px;
  border: 1px solid #e8e8e8;
  border-radius: 14px;
  padding: 12px 10px;
  margin-bottom: 8px;
  min-height: 72px;
  box-sizing: border-box;
}
.thumb {
  width: 48px;
  height: 48px;
  border-radius: 10px;
  background: #f2f2f2;
}
.meta {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 6px;
  justify-content: center;
}
.name {
  font-size: 14px;
  color: #222;
  font-weight: 600;
}
.sub {
  font-size: 12px;
  color: #777;
}
.row-action {
  width: 26px;
  height: 26px;
  border-radius: 13px;
  background: #f4f8e8;
  color: #9ebc86;
  text-align: center;
  line-height: 26px;
  font-size: 16px;
}
.row-action.selected {
  background: #9ebc86;
  color: #fff;
}
.bottom-selected {
  position: fixed;
  left: 16px;
  right: 16px;
  bottom: 12px;
  height: 72px;
  border-radius: 18px;
  border: 1px solid #d7e3be;
  background: #f4f8e8;
  padding: 10px 12px;
  box-sizing: border-box;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.left {
  display: flex;
  align-items: center;
  gap: 8px;
}
.panda {
  width: 36px;
  height: 36px;
}
.text-col {
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.meal {
  font-size: 13px;
  font-weight: 600;
  color: #212121;
}
.summary-row {
  display: flex;
  align-items: baseline;
  gap: 3px;
}
.summary {
  font-size: 11px;
  color: #6f6f6f;
}
.kcal {
  font-size: 13px;
  font-weight: 700;
  color: #8eaf57;
}
.done-btn {
  width: 92px;
  height: 38px;
  border-radius: 19px;
  background: #bfd98a;
  color: #4b5b2d;
  font-size: 14px;
  font-weight: 600;
  text-align: center;
  line-height: 38px;
}
</style>

