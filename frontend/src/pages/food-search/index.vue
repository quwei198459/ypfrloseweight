<template>
  <view class="page" :class="{ 'page--with-bar': showBottomBar }">
    <view class="hero-bg" />
    <view class="search-row">
      <view class="search-box">
        <text class="search-icon">🔍</text>
        <text class="search-placeholder">海量食物库搜索</text>
      </view>
      <view class="custom-add" @click="customVisible = true">＋</view>
    </view>

    <view class="content">
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
            <view class="name-line">
              <view v-if="giTagText(f.giLevel)" class="gi-tag" :class="'gi-' + f.giLevel">
                {{ giTagText(f.giLevel) }}
              </view>
              <text class="name">{{ f.name }}</text>
            </view>
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

    <SelectedRecordBar
      :visible="selectedRows.length > 0 && !recordSummaryVisible"
      :meal-label="mealLabel"
      :count="selectedRows.length"
      :total-kcal="selectedKcal"
      @open="openRecordSummary"
      @complete="finishSelection"
    />

    <RecordSummaryPopup
      :visible="recordSummaryVisible"
      :meal-menu-visible="summaryMealMenuVisible"
      :meal-type="mealType"
      :meal-label="mealLabel"
      :total-kcal="selectedKcal"
      :items="summaryItems"
      @close="closeRecordSummary"
      @toggle-meal-menu="summaryMealMenuVisible = !summaryMealMenuVisible"
      @pick-meal="onSummaryPickMeal"
      @remove="removeSelected"
      @complete="onSummaryComplete"
    />

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
import RecordSummaryPopup from '@/components/food-search/RecordSummaryPopup.vue'
import SelectedRecordBar from '@/components/food-search/SelectedRecordBar.vue'

type FoodItem = {
  id: string
  category: string
  name: string
  calories: number
  caloriesText: string
  image?: string
  /** 与接口 gi_level / giLevel 一致：low | medium | high，缺省则不展示标签 */
  giLevel?: 'low' | 'medium' | 'high'
}

const categories = [
  { code: 'common', name: '常用' },
  { code: 'fruit', name: '水果' },
  { code: 'grain', name: '主食' },
  { code: 'protein', name: '蛋白' },
]
const allFoods = ref<FoodItem[]>([
  { id: 'f1', category: 'fruit', name: '桔子', calories: 72, caloriesText: '72千卡/1个', giLevel: 'low' },
  { id: 'f2', category: 'grain', name: '米饭', calories: 300, caloriesText: '300千卡/1大份', giLevel: 'high' },
  { id: 'f3', category: 'protein', name: '鸡胸肉', calories: 132, caloriesText: '132千卡/100g', giLevel: 'medium' },
])

const category = ref('common')
const selectedIds = ref<string[]>([])
const mealType = ref<'breakfast' | 'lunch' | 'dinner' | 'snack'>('lunch')
const customVisible = ref(false)
const recordSummaryVisible = ref(false)
const summaryMealMenuVisible = ref(false)

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
const summaryItems = computed(() =>
  selectedRows.value.map((f) => ({
    id: f.id,
    name: f.name,
    caloriesText: f.caloriesText,
    image: f.image,
  })),
)
const showBottomBar = computed(() => selectedRows.value.length > 0 && !recordSummaryVisible.value)

onLoad((query) => {
  const fromMeal = String(query?.mealType || 'lunch')
  if (fromMeal === 'breakfast' || fromMeal === 'lunch' || fromMeal === 'dinner' || fromMeal === 'snack') {
    mealType.value = fromMeal
  }
})

function giTagText(level?: string) {
  if (level === 'high') return '高GI'
  if (level === 'medium') return '中GI'
  if (level === 'low') return '低GI'
  return ''
}

function toggleSelect(id: string) {
  const idx = selectedIds.value.indexOf(id)
  if (idx >= 0) selectedIds.value.splice(idx, 1)
  else selectedIds.value.push(id)
}

function openRecordSummary() {
  summaryMealMenuVisible.value = false
  recordSummaryVisible.value = true
}

function closeRecordSummary() {
  recordSummaryVisible.value = false
  summaryMealMenuVisible.value = false
}

function onSummaryPickMeal(value: string) {
  if (value === 'breakfast' || value === 'lunch' || value === 'dinner' || value === 'snack') {
    mealType.value = value
  }
  summaryMealMenuVisible.value = false
}

function removeSelected(id: string) {
  const idx = selectedIds.value.indexOf(id)
  if (idx >= 0) selectedIds.value.splice(idx, 1)
  if (selectedIds.value.length === 0) closeRecordSummary()
}

function finishSelection() {
  uni.navigateBack({
    fail: () => {
      uni.showToast({ title: '已完成', icon: 'none' })
    },
  })
}

function onSummaryComplete() {
  closeRecordSummary()
  finishSelection()
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
/* 与 SelectedRecordBar.vue 中 .bar 的 bottom、height 保持一致 */
$selected-bar-height: 76px;
$selected-bar-bottom: 12px;
$gap-content-to-bar: 12px;
$page-bottom-relaxed: 16px;

.page {
  height: 100vh;
  min-height: 100vh;
  box-sizing: border-box;
  background: #f7fbf7;
  position: relative;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  padding-bottom: calc(#{$page-bottom-relaxed} + env(safe-area-inset-bottom, 0px));
}
.page--with-bar {
  padding-bottom: calc(
    #{$selected-bar-height} + env(safe-area-inset-bottom, 0px)
  );
}
.hero-bg {
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  height: 138px;
  background: #bfd9a3;
  border-radius: 0 0 24px 24px;
  z-index: 0;
}
.search-row {
  position: relative;
  z-index: 2;
  flex-shrink: 0;
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
  flex: 1;
  min-height: 0;
  margin: -18px 16px 0;
  border-radius: 22px;
  background: #fff;
  border: 1px solid #e0ead2;
  padding: 10px;
  box-sizing: border-box;
  display: flex;
  gap: 8px;
  align-items: stretch;
  margin-top: 10rpx;
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
  align-items: center;
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
.name-line {
  display: flex;
  align-items: center;
  flex-wrap: nowrap;
  gap: 6px;
  min-width: 0;
}
.gi-tag {
  flex-shrink: 0;
  font-size: 10px;
  line-height: 16px;
  padding: 0 6px;
  border-radius: 6px;
}
.gi-low {
  color: #5f8d45;
  background: #e8f5e9;
}
.gi-medium {
  color: #d38645;
  background: #fff3e0;
}
.gi-high {
  color: #d16f6f;
  background: #ffebee;
}
.name {
  flex: 1;
  min-width: 0;
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
</style>

