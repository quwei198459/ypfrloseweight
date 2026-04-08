<template>
  <view class="page">
    <view class="top-hero-section">
      <view class="hero-bg" />

      <view class="search-area">
        <view class="search-input-wrapper">
          <SearchInputBar placeholder="搜索运动项目" @click-search="onSearchClick" />
        </view>
        <AddCircleButton @click="openCustomSportPopup" />
      </view>

      <view class="content-scroll">
        <view class="main-card">
          <scroll-view scroll-y class="sport-scroll" :show-scrollbar="false">
            <view class="sport-list-area">
              <sport-list-item
                v-for="item in sports"
                :key="item.id"
                :name="item.name"
                :calories-text="item.caloriesText"
                @select="openRecordPopup(item)"
              />
            </view>
          </scroll-view>
        </view>
      </view>
    </view>

    <sport-record-popup
      v-model:visible="recordPopupVisible"
      :sport-name="currentSport?.name || ''"
      :calories-text="currentSport?.caloriesText || ''"
      @confirm="onRecordConfirm"
      @cancel="recordPopupVisible = false"
    />

    <submit-loading-mask :visible="submitting" />
  </view>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import SearchInputBar from '@/components/SearchInputBar.vue'
import AddCircleButton from '@/components/AddCircleButton.vue'
import { searchSportLibrary, createSportRecord } from '@/api/sport'
import { mapSportsToPickerRows, type SportPickerRow } from '@/api/adapters/sportList'
import { resolveUserId, STORAGE_TOKEN } from '@/config/api'
import { formatRecordedAtNow } from '@/utils/recordedAt'

const sports = ref<SportPickerRow[]>([])

const recordPopupVisible = ref(false)
const submitting = ref(false)
const currentSport = ref<SportPickerRow | null>(null)

async function loadSports() {
  try {
    const raw = await searchSportLibrary(undefined, 100)
    sports.value = mapSportsToPickerRows(raw)
  } catch {
    sports.value = []
  }
}

onMounted(() => {
  void loadSports()
})

const onSearchClick = () => {
  // 留空：后续可扩展
}

const openRecordPopup = (item: SportPickerRow) => {
  currentSport.value = item
  recordPopupVisible.value = true
}

const openCustomSportPopup = () => {
  currentSport.value = {
    id: 'custom',
    name: '自定义运动',
    caloriesText: '按分钟估算',
    caloriesPerMin: 4,
  }
  recordPopupVisible.value = true
}

const onRecordConfirm = async (duration: string) => {
  const token = uni.getStorageSync(STORAGE_TOKEN) as string | undefined
  if (!token) {
    uni.showToast({ title: '请先登录', icon: 'none' })
    return
  }
  const uid = resolveUserId()
  const sp = currentSport.value
  if (!sp) return
  const minutes = Math.max(1, Math.floor(Number(duration) || 0))
  if (!Number.isFinite(minutes)) {
    uni.showToast({ title: '请输入有效时长', icon: 'none' })
    return
  }
  const cal = Math.max(0, Math.round(sp.caloriesPerMin * minutes))
  submitting.value = true
  try {
    await createSportRecord(uid, token, {
      sportName: sp.name,
      durationMin: minutes,
      calories: cal,
      icon: sp.icon,
      recordedAt: formatRecordedAtNow(),
    })
    uni.showToast({ title: '已记录', icon: 'success' })
    uni.navigateTo({ url: '/pages/daily-record/index' })
  } catch (e: unknown) {
    const msg = e instanceof Error ? e.message : '提交失败'
    uni.showToast({ title: msg, icon: 'none' })
  } finally {
    submitting.value = false
  }
}
</script>

<style scoped lang="scss">
.page {
  height: 100vh;
  background: #f7fbf7;
  padding: 0 0 90px;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  position: relative;
  overflow: hidden;
}

.top-hero-section {
  position: relative;
  width: 100%;
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
}

.hero-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 226px;
  background-color: #bfd9a3;
  border-radius: 0 0 24px 24px;
  z-index: 0;
}

.search-area {
  margin: 16px 16px 0;
  display: flex;
  align-items: center;
  gap: 8px;
  position: relative;
  z-index: 2;
}

.search-input-wrapper {
  flex: 1;
  min-width: 0;
}

.content-scroll {
  margin: 12px 16px 0;
  flex: 1;
  z-index: 1;
  min-height: 0;
  position: relative;
  display: flex;
}

.main-card {
  flex: 1;
  min-height: 0;
  position: relative;
  z-index: 2;
  border-radius: 24px;
  background: #ffffff;
  padding: 12px;
  display: flex;
  gap: 8px;
  box-sizing: border-box;
  border: 1px solid #e0ead2;
  align-items: stretch;
  height: 100%;
}

.sport-scroll {
  flex: 1;
  flex-shrink: 0;
  min-height: 0;
}

.sport-list-area {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 8px;
}
</style>
