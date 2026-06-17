<template>
  <view class="page" :class="{ 'page--with-bar': showBottomBar }">
    <view class="hero-bg" />
    <view class="search-row">
      <view class="search-box">
        <text class="search-icon">🔍</text>
        <input
          v-model="searchKeyword"
          class="search-input"
          type="text"
          confirm-type="search"
          placeholder="海量食物库搜索"
          placeholder-class="search-placeholder"
        />
      </view>
      <view class="custom-add" @click="customVisible = true">＋</view>
    </view>

    <view class="content">
      <scroll-view scroll-y class="sidebar-scroll" :show-scrollbar="false">
        <view
          v-for="c in categories"
          :key="c.code"
          class="cat"
          :class="{ active: c.code === categoryCode }"
          @click="onPickCategory(c.code)"
        >
          <text>{{ c.name }}</text>
          <view v-if="c.code === categoryCode" class="cat-underline" />
        </view>
      </scroll-view>

      <scroll-view scroll-y class="list" :show-scrollbar="false">
        <view v-if="listLoading" class="list-hint">加载中…</view>
        <view v-else-if="!filteredFoods.length" class="list-hint">暂无食物</view>
        <view
          v-for="f in filteredFoods"
          v-else
          :key="f.id"
          class="food-row"
          @click="openFoodDetail(f)"
        >
          <image
            class="thumb"
            :src="rowThumbSrc(f)"
            mode="aspectFill"
            @error="onFoodRowImgErr(f.id)"
          />
          <view class="meta">
            <view class="name-line">
              <view
                v-if="giTagText(f.giLevel)"
                class="gi-tag"
                :class="'gi-' + f.giLevel"
                @click.stop="goGiGuide"
              >
                {{ giTagText(f.giLevel) }}
              </view>
              <text class="name">{{ f.name }}</text>
            </view>
            <text class="sub">{{ f.calorieSummary || f.unit }}</text>
          </view>
          <view
            class="row-action"
            :class="{ selected: Boolean(draftByFoodId[f.id]) }"
            @click.stop="toggleRowQuick(f)"
          >
            {{ draftByFoodId[f.id] ? '✓' : '+' }}
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
      @remove="removeDraft"
      @complete="onSummaryComplete"
    />

    <FoodDetailPopup
      :visible="detailVisible"
      hide-meal-bar
      :meal-menu-visible="false"
      :meal-type="mealType"
      :meal-label="mealLabel"
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
      @confirm="confirmFoodDetail"
      @go-gi-guide="goGiGuide"
      @set-mode="(m) => (detailMode = m)"
    />

    <CustomFoodPopup
      v-model:visible="customVisible"
      :confirm-loading="customSubmitting"
      @cancel="customVisible = false"
      @confirm="handleCustomConfirm"
    />
  </view>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { onLoad } from '@dcloudio/uni-app'
import { createCustomFood, listFoodCategories, searchFoodLibrary, type FoodCategoryItemJson } from '@/api/food'
import { FOOD_IMAGE_PLACEHOLDER } from '@/constants/foodImage'
import { createMealRecordsBatch } from '@/api/meal'
import { mapFoodsToSearchItems } from '@/api/adapters/searchFood'
import CustomFoodPopup from '@/components/CustomFoodPopup.vue'
import FoodDetailPopup from '@/components/food-search/FoodDetailPopup.vue'
import RecordSummaryPopup from '@/components/food-search/RecordSummaryPopup.vue'
import SelectedRecordBar from '@/components/food-search/SelectedRecordBar.vue'
import { resolveUserId, STORAGE_TOKEN } from '@/config/api'
import type { SearchFoodItem } from '@/types/searchFood'
import { formatLocalDate } from '@/utils/date'
import { formatRecordedAtForYmd } from '@/utils/recordedAt'
import { useUserStore } from '@/stores/user'

type DraftEntry = {
  foodId: number
  amountValue: number
  amountUnit: string
  inputMode: 'gram' | 'portion'
  item: SearchFoodItem
}

const userStore = useUserStore()

const categories = ref<FoodCategoryItemJson[]>([])
const categoryCode = ref('')
const searchKeyword = ref('')
const allFoods = ref<SearchFoodItem[]>([])
const listLoading = ref(false)
const recordDateYmd = ref(formatLocalDate(new Date()))

const draftByFoodId = ref<Record<string, DraftEntry>>({})

const mealType = ref<'breakfast' | 'lunch' | 'dinner' | 'snack'>('lunch')
/** 列表缩略图加载失败（如 404）时按 id 回退到统一占位图 */
const rowThumbFailed = ref<Record<string, boolean>>({})

function rowThumbSrc(f: SearchFoodItem) {
  if (rowThumbFailed.value[f.id]) return FOOD_IMAGE_PLACEHOLDER
  return (f.image || '').trim() || FOOD_IMAGE_PLACEHOLDER
}

function onFoodRowImgErr(id: string) {
  rowThumbFailed.value = { ...rowThumbFailed.value, [id]: true }
}

const customVisible = ref(false)
const customSubmitting = ref(false)
const recordSummaryVisible = ref(false)
const summaryMealMenuVisible = ref(false)
const submitLoading = ref(false)

const detailVisible = ref(false)
const detailFood = ref<SearchFoodItem | null>(null)
const detailQty = ref('1')
const detailMode = ref<'gram' | 'portion'>('gram')

let searchDebounce: ReturnType<typeof setTimeout> | null = null

const filteredFoods = computed(() => allFoods.value)

const selectedRows = computed(() => Object.values(draftByFoodId.value).map((d) => d.item))

const selectedKcal = computed(() =>
  Object.values(draftByFoodId.value).reduce((s, d) => s + estimateKcal(d.item, d.amountValue, d.inputMode), 0),
)

const mealLabel = computed(() => {
  if (mealType.value === 'breakfast') return '早餐'
  if (mealType.value === 'dinner') return '晚餐'
  if (mealType.value === 'snack') return '加餐'
  return '午餐'
})

const summaryItems = computed(() =>
  Object.values(draftByFoodId.value).map((d) => ({
    id: d.item.id,
    name: d.item.name,
    caloriesText: `${estimateKcal(d.item, d.amountValue, d.inputMode)}千卡/${formatAmountUnit(d)}`,
    image: d.item.image,
  })),
)

const showBottomBar = computed(() => selectedRows.value.length > 0 && !recordSummaryVisible.value)

function foodSearchTitle(ymd: string) {
  const parts = ymd.split('-')
  if (parts.length !== 3) return '今日饮食'
  const month = Number(parts[1])
  const day = Number(parts[2])
  if (!Number.isFinite(month) || !Number.isFinite(day)) return '今日饮食'
  return `${month}月${day}日饮食`
}

onLoad((query) => {
  const fromMeal = String(query?.mealType || 'lunch')
  if (fromMeal === 'breakfast' || fromMeal === 'lunch' || fromMeal === 'dinner' || fromMeal === 'snack') {
    mealType.value = fromMeal
  }
  const qd = String(query?.date || '').trim()
  if (/^\d{4}-\d{2}-\d{2}$/.test(qd)) {
    recordDateYmd.value = qd
  }
  uni.setNavigationBarTitle({ title: foodSearchTitle(recordDateYmd.value) })
  void loadCategories()
})

watch(categoryCode, () => {
  void fetchFoodList()
})

watch(searchKeyword, () => {
  if (searchDebounce != null) clearTimeout(searchDebounce)
  searchDebounce = setTimeout(() => {
    void fetchFoodList()
  }, 280)
})

function formatAmountUnit(d: DraftEntry): string {
  if (d.inputMode === 'gram' || d.amountUnit === 'g' || d.amountUnit === '克') {
    return `${d.amountValue}克`
  }
  return `${d.amountValue}${d.amountUnit}`
}

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

function consumedGrams(food: SearchFoodItem, amount: number, mode: 'gram' | 'portion'): number {
  if (mode === 'portion') {
    return amount * (food.servingWeightG > 0 ? food.servingWeightG : 100)
  }
  return amount
}

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
  const curK = estimateKcal(f, parsePositiveNumber(detailQty.value), detailMode.value)
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

function giTagText(level?: string) {
  if (level === 'high') return '高GI'
  if (level === 'medium') return '中GI'
  if (level === 'low') return '低GI'
  return ''
}

function goGiGuide() {
  uni.navigateTo({ url: '/pages/gi-guide/index' })
}

async function loadCategories() {
  try {
    const token = userStore.token || (uni.getStorageSync(STORAGE_TOKEN) as string | undefined)
    const list = await listFoodCategories(token)
    const sorted = [...list].sort((a, b) => (a.sortNo ?? 0) - (b.sortNo ?? 0))
    categories.value = sorted
    if (sorted.length && !categoryCode.value) {
      categoryCode.value = sorted[0].code
    } else {
      void fetchFoodList()
    }
  } catch {
    uni.showToast({ title: '分类加载失败', icon: 'none' })
  }
}

function onPickCategory(code: string) {
  categoryCode.value = code
}

async function fetchFoodList() {
  if (!categoryCode.value) return
  listLoading.value = true
  try {
    const token = userStore.token || (uni.getStorageSync(STORAGE_TOKEN) as string | undefined)
    const q = searchKeyword.value.trim()
    const raw = await searchFoodLibrary(q || undefined, 80, token, resolveUserId(), categoryCode.value)
    rowThumbFailed.value = {}
    allFoods.value = mapFoodsToSearchItems(raw)
  } catch {
    allFoods.value = []
  } finally {
    listLoading.value = false
  }
}

function openFoodDetail(f: SearchFoodItem) {
  detailFood.value = f
  const exist = draftByFoodId.value[f.id]
  if (exist) {
    detailQty.value = String(exist.amountValue)
    detailMode.value = exist.inputMode
  } else {
    detailQty.value = '1'
    detailMode.value =
      f.servingWeightG > 0 ? 'portion' : f.calorieIsPer100g ? 'gram' : 'portion'
  }
  detailVisible.value = true
}

function closeFoodDetail() {
  detailVisible.value = false
  detailFood.value = null
}

function toggleRowQuick(f: SearchFoodItem) {
  if (draftByFoodId.value[f.id]) {
    const next = { ...draftByFoodId.value }
    delete next[f.id]
    draftByFoodId.value = next
    return
  }
  openFoodDetail(f)
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

function confirmFoodDetail() {
  const f = detailFood.value
  if (!f) return
  const amount = parsePositiveNumber(detailQty.value)
  const unit =
    detailMode.value === 'gram'
      ? 'g'
      : f.calorieIsPer100g
        ? '份'
        : f.portionUnitLabel || '份'
  draftByFoodId.value = {
    ...draftByFoodId.value,
    [f.id]: {
      foodId: Number(f.id),
      amountValue: amount,
      amountUnit: unit,
      inputMode: detailMode.value,
      item: f,
    },
  }
  closeFoodDetail()
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

function removeDraft(id: string) {
  const next = { ...draftByFoodId.value }
  delete next[id]
  draftByFoodId.value = next
  if (Object.keys(next).length === 0) closeRecordSummary()
}

async function finishSelection() {
  const entries = Object.values(draftByFoodId.value)
  if (entries.length === 0) {
    uni.showToast({ title: '请先选择食物', icon: 'none' })
    return
  }
  const token = userStore.token || (uni.getStorageSync(STORAGE_TOKEN) as string | undefined)
  if (!token) {
    uni.showToast({ title: '请先登录', icon: 'none' })
    return
  }
  if (submitLoading.value) return
  submitLoading.value = true
  try {
    await createMealRecordsBatch(resolveUserId(), token, {
      recordDate: recordDateYmd.value,
      mealType: mealType.value,
      recordedAt: formatRecordedAtForYmd(recordDateYmd.value),
      items: entries.map((e) => ({
        foodId: e.foodId,
        amountValue: e.amountValue,
        amountUnit: e.amountUnit,
      })),
    })
    draftByFoodId.value = {}
    closeRecordSummary()
    uni.navigateTo({
      url: `/pages/daily-record/index?date=${encodeURIComponent(recordDateYmd.value)}`,
    })
  } catch (e: unknown) {
    const msg = e instanceof Error ? e.message : '提交失败'
    uni.showToast({ title: msg, icon: 'none' })
  } finally {
    submitLoading.value = false
  }
}

function onSummaryComplete() {
  closeRecordSummary()
  void finishSelection()
}

async function handleCustomConfirm(payload: { name: string; weight: string; calories: string }) {
  const name = payload.name.trim()
  const calories = Number(payload.calories)
  const weight = Number(payload.weight)
  if (!name || !Number.isFinite(calories) || calories <= 0 || !Number.isFinite(weight) || weight <= 0) {
    uni.showToast({ title: '请填写有效食物信息', icon: 'none' })
    return
  }
  const token = userStore.token || (uni.getStorageSync(STORAGE_TOKEN) as string | undefined)
  if (!token) {
    uni.showToast({ title: '请先登录', icon: 'none' })
    return
  }
  customSubmitting.value = true
  try {
    await createCustomFood(resolveUserId(), token, {
      name,
      weightG: Math.round(weight),
      calories: Math.round(calories),
    })
    customVisible.value = false
    uni.showToast({ title: '已保存', icon: 'none' })
    void fetchFoodList()
  } catch (e: unknown) {
    const msg = e instanceof Error ? e.message : '保存失败'
    uni.showToast({ title: msg, icon: 'none' })
  } finally {
    customSubmitting.value = false
  }
}
</script>

<style scoped lang="scss">
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
    #{$selected-bar-bottom} + #{$selected-bar-height} + #{$gap-content-to-bar} + env(safe-area-inset-bottom, 0px)
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
.search-input {
  flex: 1;
  height: 38px;
  font-size: 13px;
  color: #222;
}
.search-placeholder {
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
.list-hint {
  padding: 24px 8px;
  font-size: 13px;
  color: #999;
  text-align: center;
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
