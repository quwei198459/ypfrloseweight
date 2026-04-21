<template>
  <view class="search-page">
    <view class="search-header-area">
      <view class="search-input-row">
        <!-- 微信小程序下自定义组件默认不参与 flex 伸展，需外包一层占满剩余宽度 -->
        <view class="search-input-bar-wrap">
          <SearchInputBar
            v-model="searchKeyword"
            :placeholder="searchPlaceholder"
            @camera="onCamera"
          />
        </view>
        <text class="cancel-text-button" @click="onCancel">取消</text>
      </view>
      <view class="header-bottom-wave">
        <view class="wave-bump wave-bump-left" />
        <view class="wave-bump wave-bump-mid" />
        <view class="wave-bump wave-bump-center" />
        <view class="wave-bump wave-bump-right" />
      </view>
    </view>

    <view class="search-content-area">
      <view v-if="!showResults" class="empty-state">
        <view class="empty-illustration">
          <text class="empty-emoji">🐼</text>
        </view>
        <text class="empty-text">搜一搜食物热量，开始记录吧~</text>
      </view>
      <scroll-view v-else scroll-y class="scroll-list-container" :show-scrollbar="false">
        <view class="food-result-list">
          <FoodResultItem
            v-for="item in filteredList"
            :key="item.id"
            :food="item"
            @select="onSelectFood"
          />
        </view>
      </scroll-view>
    </view>

    <FoodDetailPopup
      :visible="detailVisible"
      hide-meal-bar
      :meal-menu-visible="false"
      meal-type="snack"
      meal-label="加餐"
      :quantity-text="detailQty"
      :input-mode="detailMode"
      :portion-unit-label="detailFood?.portionUnitLabel || '份'"
      :center-kcal="detailCenterKcal"
      :standard-weight-g="detailFood?.servingWeightG ?? 0"
      :food="detailFoodPopupModel"
      @close="closeFoodDetail"
      @toggle-meal-menu="() => {}"
      @pick-meal="() => {}"
      @key="onDetailKey"
      @delete="onDetailDelete"
      @confirm="onRecordConfirm"
      @go-gi-guide="goGiGuide"
      @set-mode="(m) => (detailMode = m)"
    />
  </view>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import SearchInputBar from '@/components/search/SearchInputBar.vue'
import FoodResultItem from '@/components/search/FoodResultItem.vue'
import FoodDetailPopup from '@/components/food-search/FoodDetailPopup.vue'
import { createMealRecordsBatch } from '@/api/meal'
import { searchFoodLibrary } from '@/api/food'
import { buildBatchItemFromSearchSelection } from '@/api/adapters/searchMealRecord'
import { mapFoodsToSearchItems } from '@/api/adapters/searchFood'
import { resolveUserId, STORAGE_TOKEN } from '@/config/api'
import { useUserStore } from '@/stores/user'
import { formatLocalDate } from '@/utils/date'
import { formatRecordedAtForYmd } from '@/utils/recordedAt'
import type { SearchFoodItem } from '@/types/searchFood'

const userStore = useUserStore()

const searchKeyword = ref('')
const apiFoods = ref<SearchFoodItem[]>([])
let searchDebounce: ReturnType<typeof setTimeout> | null = null

const detailVisible = ref(false)
const detailFood = ref<SearchFoodItem | null>(null)
const detailQty = ref('1')
const detailMode = ref<'gram' | 'portion'>('gram')
const submitLoading = ref(false)

const showResults = computed(() => searchKeyword.value.trim().length > 0)

const searchPlaceholder = computed(() =>
  showResults.value ? '' : '10w+ 食物库热量查询',
)

const filteredList = computed(() => apiFoods.value)

function parsePositiveNumber(s: string): number {
  const n = Number(String(s ?? '').trim())
  return Number.isFinite(n) && n > 0 ? n : 1
}

function estimateKcal(food: SearchFoodItem, amount: number, mode: 'gram' | 'portion'): number {
  if (mode === 'portion') {
    if (food.calorieIsPer100g) {
      const g = amount * (food.servingWeightG > 0 ? food.servingWeightG : 100)
      return Math.max(1, Math.round((food.calorie * g) / 100))
    }
    return Math.max(1, Math.round(food.calorie * amount))
  }
  if (food.calorieIsPer100g) {
    return Math.max(1, Math.round((food.calorie * amount) / 100))
  }
  const denom = food.servingWeightG > 0 ? food.servingWeightG : 100
  return Math.max(1, Math.round((food.calorie * amount) / denom))
}

/** 与热量换算使用同一套克数口径（见 docs 食物库每百克 + 标准份克数） */
function consumedGrams(food: SearchFoodItem, amount: number, mode: 'gram' | 'portion'): number {
  if (mode === 'portion') {
    return amount * (food.servingWeightG > 0 ? food.servingWeightG : 100)
  }
  return amount
}

/** 宏量按每 100g 营养 × 当前食用克数；热量比例用于非每百克路径与热量对齐 */
function scaledMacrosForPopup(
  food: SearchFoodItem,
  qtyStr: string,
  mode: 'gram' | 'portion',
  curKcal: number,
): { proteinG: number; fatG: number; carbsG: number } {
  const q = parsePositiveNumber(qtyStr)
  const gNow = consumedGrams(food, q, mode)
  const p100 = food.proteinG ?? 0
  const f100 = food.fatG ?? 0
  const c100 = food.carbsG ?? 0
  if (food.calorieIsPer100g) {
    return {
      proteinG: (p100 * gNow) / 100,
      fatG: (f100 * gNow) / 100,
      carbsG: (c100 * gNow) / 100,
    }
  }
  const refMode = food.servingWeightG > 0 ? 'portion' : 'gram'
  const refK = estimateKcal(food, 1, refMode)
  const gRef = consumedGrams(food, 1, refMode)
  const ratio = refK > 0 ? curKcal / refK : 0
  return {
    proteinG: ((p100 * gRef) / 100) * ratio,
    fatG: ((f100 * gRef) / 100) * ratio,
    carbsG: ((c100 * gRef) / 100) * ratio,
  }
}

const detailFoodPopupModel = computed(() => {
  const f = detailFood.value
  if (!f) return null
  const q = parsePositiveNumber(detailQty.value)
  const curK = estimateKcal(f, q, detailMode.value)
  const m = scaledMacrosForPopup(f, detailQty.value, detailMode.value, curK)
  return {
    id: f.id,
    name: f.name,
    calories: f.calorie,
    caloriesText: f.calorieSummary || `${f.calorie} ${f.unit}`,
    proteinG: m.proteinG,
    fatG: m.fatG,
    carbsG: m.carbsG,
    giLevel: f.giLevel,
    image: f.image,
  }
})

const detailCenterKcal = computed(() => {
  const f = detailFood.value
  if (!f) return 0
  const q = parsePositiveNumber(detailQty.value)
  return estimateKcal(f, q, detailMode.value)
})

watch(searchKeyword, (kw) => {
  if (searchDebounce != null) clearTimeout(searchDebounce)
  const q = kw.trim()
  if (!q) {
    apiFoods.value = []
    return
  }
  searchDebounce = setTimeout(() => {
    void (async () => {
      try {
        const token = userStore.token || (uni.getStorageSync(STORAGE_TOKEN) as string | undefined)
        const raw = await searchFoodLibrary(q, 40, token, resolveUserId())
        apiFoods.value = mapFoodsToSearchItems(raw)
      } catch {
        apiFoods.value = []
      }
    })()
  }, 300)
})

const onCancel = () => {
  uni.navigateBack({ delta: 1 })
}

const onCamera = () => {
  uni.switchTab({ url: '/pages/photograph/index' })
}

function goGiGuide() {
  uni.navigateTo({ url: '/pages/gi-guide/index' })
}

const onSelectFood = (food: SearchFoodItem) => {
  detailFood.value = food
  detailQty.value = '1'
  // 有标准份克数时默认「份/碗」，避免每百克食物误选「克」导致 1g≈1 千卡
  detailMode.value =
    food.servingWeightG > 0 ? 'portion' : food.calorieIsPer100g ? 'gram' : 'portion'
  detailVisible.value = true
}

function closeFoodDetail() {
  detailVisible.value = false
  detailFood.value = null
}

function onDetailKey(key: string) {
  const cur = detailQty.value
  if (key === '.') {
    if (cur.includes('.')) return
    detailQty.value = cur === '' ? '0.' : cur + '.'
    return
  }
  if (key === '0' && cur === '0') return
  if (cur === '0' && key !== '.') {
    detailQty.value = key
    return
  }
  detailQty.value = cur + key
}

function onDetailDelete() {
  const cur = detailQty.value
  if (cur.length <= 1) {
    detailQty.value = '0'
    return
  }
  detailQty.value = cur.slice(0, -1)
}

const onRecordConfirm = async () => {
  const food = detailFood.value
  if (!food) {
    uni.showToast({ title: '请选择食物', icon: 'none' })
    return
  }
  const token = uni.getStorageSync(STORAGE_TOKEN) as string | undefined
  if (!token) {
    uni.showToast({ title: '请先登录', icon: 'none' })
    return
  }
  const uid = resolveUserId()
  if (!uid) {
    uni.showToast({ title: '请先登录', icon: 'none' })
    return
  }
  const item = buildBatchItemFromSearchSelection(food, detailQty.value, detailMode.value)
  if (!item) {
    uni.showToast({ title: '请输入有效数量', icon: 'none' })
    return
  }
  if (submitLoading.value) return
  submitLoading.value = true
  uni.showLoading({ title: '提交中', mask: true })
  const ymd = formatLocalDate(new Date())
  try {
    await createMealRecordsBatch(uid, token, {
      recordDate: ymd,
      mealType: 'snack',
      recordedAt: formatRecordedAtForYmd(ymd),
      items: [item],
    })
    closeFoodDetail()
    uni.navigateTo({
      url: `/pages/record-success/index?date=${encodeURIComponent(ymd)}`,
    })
  } catch (e: unknown) {
    const msg = e instanceof Error ? e.message : '记录失败'
    uni.showToast({ title: msg, icon: 'none' })
  } finally {
    uni.hideLoading()
    submitLoading.value = false
  }
}
</script>

<style lang="scss" scoped>
.search-page {
  width: 100%;
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: #f7fbf7;
  box-sizing: border-box;
}

/* 设计稿 search-header-area：#B8D98C，padding 12，底部 gap 6 */
.search-header-area {
  flex-shrink: 0;
  background: #b8d98c;
  padding: 24rpx 24px 12rpx 24px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 12rpx;
}

.search-input-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 20rpx;
  width: 100%;
  box-sizing: border-box;
}

.search-input-bar-wrap {
  flex: 1;
  min-width: 0;
  /* width:0 + flex:1 让子项在小程序里稳定吃满「搜索框 + 取消」之间的剩余空间 */
  width: 0;
}

.cancel-text-button {
  flex-shrink: 0;
  font-size: 28rpx;
  font-weight: normal;
  color: #424242;
}

.header-bottom-wave {
  display: flex;
  flex-direction: row;
  align-items: flex-end;
  justify-content: center;
  height: 36rpx;
  padding: 0 20rpx;
  box-sizing: border-box;
  gap: 8rpx;
  background: #b8d98c;
}

.wave-bump {
  background: #b8d98c;
  border-radius: 28rpx;
}

.wave-bump-left {
  width: 112rpx;
  height: 32rpx;
  border-radius: 28rpx;
}

.wave-bump-mid {
  width: 176rpx;
  height: 48rpx;
  border-radius: 40rpx;
}

.wave-bump-center {
  width: 240rpx;
  height: 36rpx;
  border-radius: 44rpx;
}

.wave-bump-right {
  width: 144rpx;
  height: 40rpx;
  border-radius: 36rpx;
}

.search-content-area {
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
  padding: 0 24rpx;
  box-sizing: border-box;
  background: #f7fbf7;
}

.empty-state {
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40rpx 32rpx 72rpx;
  box-sizing: border-box;
  background: #ffffff;
  margin: 0 -24rpx;
}

.empty-illustration {
  width: 440rpx;
  height: 336rpx;
  border-radius: 48rpx;
  background: #f5f5f5;
  border: 1rpx solid #e8e8e8;
  display: flex;
  align-items: center;
  justify-content: center;
}

.empty-emoji {
  font-size: 96rpx;
  color: #9e9e9e;
}

.empty-text {
  margin-top: 24rpx;
  font-size: 24rpx;
  color: #9e9e9e;
  text-align: center;
  width: 100%;
}

.scroll-list-container {
  flex: 1;
  height: 0;
  min-height: 0;
}

.food-result-list {
  padding: 16rpx 0 32rpx;
  box-sizing: border-box;
}
</style>
