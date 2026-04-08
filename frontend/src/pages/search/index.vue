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

    <FoodRecordPopup
      :visible="popupVisible"
      :food="selectedFood"
      :quantity="quantityInput"
      @update:visible="popupVisible = $event"
      @update:quantity="quantityInput = $event"
      @confirm="onRecordConfirm"
    />
  </view>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import SearchInputBar from '@/components/search/SearchInputBar.vue'
import FoodResultItem from '@/components/search/FoodResultItem.vue'
import FoodRecordPopup from '@/components/search/FoodRecordPopup.vue'
import { createMealRecord } from '@/api/meal'
import { searchFoodLibrary } from '@/api/food'
import { buildMealRecordFromSearchSelection } from '@/api/adapters/searchMealRecord'
import { mapFoodsToSearchItems } from '@/api/adapters/searchFood'
import { resolveUserId, STORAGE_TOKEN } from '@/config/api'
import { useUserStore } from '@/stores/user'
import { formatLocalDate } from '@/utils/date'
import type { SearchFoodItem } from '@/types/searchFood'

const userStore = useUserStore()

const searchKeyword = ref('')
const popupVisible = ref(false)
const selectedFood = ref<SearchFoodItem | null>(null)
const quantityInput = ref('12')
const apiFoods = ref<SearchFoodItem[]>([])
let searchDebounce: ReturnType<typeof setTimeout> | null = null

const showResults = computed(() => searchKeyword.value.trim().length > 0)

const searchPlaceholder = computed(() =>
  showResults.value ? '' : '10w+ 食物库热量查询',
)

const filteredList = computed(() => apiFoods.value)

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

watch(popupVisible, (open) => {
  if (open && selectedFood.value) {
    quantityInput.value = '12'
  }
})

const onCancel = () => {
  uni.navigateBack({ delta: 1 })
}

const onCamera = () => {
  uni.switchTab({ url: '/pages/photograph/index' })
}

const onSelectFood = (food: SearchFoodItem) => {
  selectedFood.value = food
  quantityInput.value = '12'
  popupVisible.value = true
}

const onRecordConfirm = async () => {
  const food = selectedFood.value
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
  const body = buildMealRecordFromSearchSelection(food, quantityInput.value, 'snack')
  if (!body) {
    uni.showToast({ title: '请输入有效克数', icon: 'none' })
    return
  }
  try {
    await createMealRecord(uid, token, body)
    popupVisible.value = false
    const ymd = formatLocalDate(new Date())
    uni.showToast({ title: '已记录', icon: 'success' })
    uni.navigateTo({
      url: `/pages/daily-record/index?date=${encodeURIComponent(ymd)}`,
    })
  } catch (e: unknown) {
    const msg = e instanceof Error ? e.message : '记录失败'
    uni.showToast({ title: msg, icon: 'none' })
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
