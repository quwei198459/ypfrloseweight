<template>
  <view class="photograph-page">
    <view class="photograph-page__body">
      <PhotographPageHeader
        :show-subtitle="showHeaderSubtitle"
        :meal-label="mealLabel"
      />

      <view v-if="showMealRow" class="meal-anchor">
        <MealTypeTrigger
          :meal-label="mealLabel"
          :open="phase === 'mealtype_dropdown_open'"
          @click="onMealTriggerClick"
        />
        <view
          v-if="phase === 'mealtype_dropdown_open'"
          class="meal-anchor__dropdown"
        >
          <MealTypeDropdown
            :model-value="selectedMealType"
            @select="onSelectMeal"
          />
        </view>
      </view>

      <view class="photograph-page__preview-wrap">
        <CameraPreviewCard
          :page-state="phase"
          :preview-src="previewSrc"
          :processing-label="processingLabel"
          :processing-fill-percent="processingFillPercent"
          :food-name="primaryFood.foodName"
          :gi-label="primaryFood.giLabel"
          :calories="displayCalories"
          :badge-percent-label="recommendedPercentLabel"
          :strip-text="totalStripText"
          @edit-food="openCalorieEdit"
          @delete-food="onDeleteFoodPlaceholder"
        />
        <!-- 必须被页面引用，否则 mp 增量编译可能缺少该组件 wxss；覆盖「正在上传」阶段 -->
        <UploadLoadingMask v-if="phase === 'uploading'" />
      </view>

      <!-- 成功态底栏 -->
      <view
        v-if="phase === 'success' || phase === 'mealtype_dropdown_open'"
        class="success-bot"
      >
        <view class="success-bot__btn success-bot__btn--ghost" @click="openRatioSheet">
          <text class="success-bot__t success-bot__t--ghost">食用比例调节</text>
        </view>
        <view class="success-bot__btn success-bot__btn--solid" @click="onConfirmMain">
          <text class="success-bot__t success-bot__t--solid">确定</text>
        </view>
      </view>

      <!-- 初始 / 识图中：相册 + 快门 -->
      <view
        v-if="phase === 'idle' || isProcessing"
        class="action-row"
        :class="{ 'action-row--disabled': isProcessing }"
      >
        <view class="action-row__left">
          <view class="album-button" @click="openAlbum">
            <view class="album-button__icon-wrap">
              <text class="album-button__icon">🖼</text>
            </view>
            <text class="album-button__label">相册</text>
          </view>
        </view>
        <view class="action-row__center">
          <view class="shutter-button" @click="openCamera">
            <view class="shutter-button__outer" />
            <view class="shutter-button__inner">
              <text class="shutter-button__glyph">📷</text>
            </view>
          </view>
        </view>
        <view class="action-row__right" />
      </view>

      <FailedStatePanel
        v-if="phase === 'failed'"
        @exit="onExitPhoto"
        @continue="onContinuePhoto"
      />

      <view
        v-if="isDev"
        class="dev-hint"
        @click="openAlbumForFailDemo"
      >
        <text class="dev-hint__text">开发：模拟识图失败动画（不调接口）</text>
      </view>
    </view>

    <view
      v-if="phase === 'mealtype_dropdown_open'"
      class="page-dim"
      @click="closeMealDropdown"
    />

    <CalorieEditModal
      v-if="phase === 'editing_calorie'"
      v-model="calorieDraft"
      @confirm="confirmCalorieEdit"
      @cancel="cancelCalorieEdit"
    />

    <RatioAdjustSheet
      v-if="phase === 'adjusting_ratio'"
      :food-name="primaryFood.foodName"
      :gi-label="primaryFood.giLabel"
      :displayed-calories="sheetDisplayedCalories"
      :kcal-pair-text="ratioKcalText"
      :meal-short-label="mealLabel"
      :ratio-percent="ratioPercent"
      :intake-today="mockResult.intakeCaloriesToday"
      :daily-budget="mockResult.dailyBudgetCalories"
      @update:ratio-percent="setRatioPercent"
      @close="closeRatioSheet"
      @add="onAddFromSheet"
    />

    <PhotographSavedOverlay v-if="phase === 'saved'" />

    <view class="photograph-page__safe" />
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import CameraPreviewCard from '@/components/photograph/CameraPreviewCard.vue'
import FailedStatePanel from '@/components/photograph/FailedStatePanel.vue'
import PhotographPageHeader from '@/components/photograph/PhotographPageHeader.vue'
import MealTypeTrigger from '@/components/photograph/MealTypeTrigger.vue'
import MealTypeDropdown from '@/components/photograph/MealTypeDropdown.vue'
import CalorieEditModal from '@/components/photograph/CalorieEditModal.vue'
import RatioAdjustSheet from '@/components/photograph/RatioAdjustSheet.vue'
import PhotographSavedOverlay from '@/components/photograph/PhotographSavedOverlay.vue'
import UploadLoadingMask from '@/components/photograph/UploadLoadingMask.vue'
import { usePhotographFlow } from '@/composables/usePhotographFlow'
import type { MealTypeKey } from '@/types/photograph'

const isDev = import.meta.env.DEV

const {
  phase,
  previewSrc,
  selectedMealType,
  mockResult,
  displayCalories,
  calorieDraft,
  ratioPercent,
  mealLabel,
  processingFillPercent,
  processingLabel,
  recommendedPercentLabel,
  totalStripText,
  ratioKcalText,
  sheetDisplayedCalories,
  isProcessing,
  handleImagePicked,
  openMealDropdown,
  closeMealDropdown,
  selectMealType,
  openCalorieEdit,
  confirmCalorieEdit,
  cancelCalorieEdit,
  openRatioSheet,
  closeRatioSheet,
  onConfirmMain,
  onAddFromSheet,
  onContinuePhoto,
  onExitPhoto,
} = usePhotographFlow()

const primaryFood = computed(() => {
  const f = mockResult.value.foods[0]
  return f ?? { foodName: '', giLabel: '低 GI', calories: 0, lineId: '0' }
})

const showHeaderSubtitle = computed(() => {
  return (
    phase.value === 'success' ||
    phase.value === 'mealtype_dropdown_open' ||
    phase.value === 'editing_calorie' ||
    phase.value === 'adjusting_ratio'
  )
})

const showMealRow = computed(() => {
  if (phase.value === 'idle' || phase.value === 'failed' || phase.value === 'saved') {
    return false
  }
  return true
})

function onMealTriggerClick() {
  if (phase.value === 'success') {
    openMealDropdown()
  }
}

function onSelectMeal(key: MealTypeKey) {
  selectMealType(key)
}

function onDeleteFoodPlaceholder() {
  uni.showToast({ title: '敬请期待', icon: 'none' })
}

function openAlbum() {
  if (isProcessing.value) return
  uni.chooseImage({
    count: 1,
    sourceType: ['album'],
    success: (res) => {
      const p = res.tempFilePaths[0]
      handleImagePicked(p, { source: 'album' })
    },
  })
}

function openCamera() {
  if (isProcessing.value) return
  uni.chooseImage({
    count: 1,
    sourceType: ['camera'],
    success: (res) => {
      const p = res.tempFilePaths[0]
      handleImagePicked(p, { source: 'camera' })
    },
  })
}

function openAlbumForFailDemo() {
  uni.chooseImage({
    count: 1,
    sourceType: ['album', 'camera'],
    success: (res) => {
      const p = res.tempFilePaths[0]
      handleImagePicked(p, { failDemo: true })
    },
  })
}

function setRatioPercent(v: number) {
  ratioPercent.value = v
}
</script>

<style lang="scss" scoped>
.photograph-page {
  min-height: 100vh;
  background: #f7f8f7;
  box-sizing: border-box;
}

.photograph-page__body {
  padding: 24rpx 32rpx 0;
  box-sizing: border-box;
  position: relative;
}

.photograph-page__preview-wrap {
  position: relative;
}

.meal-anchor {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  z-index: 120;
}

.meal-anchor__dropdown {
  position: absolute;
  left: 50%;
  top: 100%;
  transform: translateX(-50%);
  margin-top: 8rpx;
  z-index: 130;
}

.page-dim {
  position: fixed;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  z-index: 110;
  background: rgba(0, 0, 0, 0.25);
}

.success-bot {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  gap: 24rpx;
  margin-top: 24rpx;
  padding: 0 12rpx 24rpx;
  box-sizing: border-box;
}

.success-bot__btn {
  flex: 1;
  max-width: 304rpx;
  height: 88rpx;
  border-radius: 44rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
}

.success-bot__btn--ghost {
  background: #ffffff;
  border: 3rpx solid #8fa67a;
}

.success-bot__btn--solid {
  background: #d5e7b1;
  border: 2rpx solid #9ebc86;
}

.success-bot__t {
  font-size: 28rpx;
  font-weight: 600;
}

.success-bot__t--ghost {
  color: #4b5b2d;
}

.success-bot__t--solid {
  color: #2d3d22;
}

.action-row {
  display: flex;
  flex-direction: row;
  align-items: flex-end;
  justify-content: space-between;
  margin-top: 32rpx;
  padding: 0 8rpx 8rpx;
  min-height: 200rpx;
}

.action-row__left {
  width: 160rpx;
  display: flex;
  justify-content: flex-start;
  align-items: center;
}

.action-row__center {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
}

.action-row__right {
  width: 160rpx;
}

.action-row--disabled {
  opacity: 0.45;
  pointer-events: none;
}

.album-button {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12rpx;
}

.album-button__icon-wrap {
  width: 56rpx;
  height: 56rpx;
  border-radius: 12rpx;
  background: #f0f0f0;
  border: 1rpx solid #e0e0e0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.album-button__icon {
  font-size: 28rpx;
  color: #555555;
  line-height: 1;
}

.album-button__label {
  font-size: 22rpx;
  color: #555555;
}

.shutter-button {
  position: relative;
  width: 144rpx;
  height: 144rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.shutter-button__outer {
  position: absolute;
  left: 0;
  top: 0;
  width: 144rpx;
  height: 144rpx;
  border-radius: 72rpx;
  background: #bfd9a3;
  border: 2rpx solid #9ebc86;
  box-sizing: border-box;
}

.shutter-button__inner {
  position: relative;
  z-index: 1;
  width: 112rpx;
  height: 112rpx;
  border-radius: 56rpx;
  background: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.06);
}

.shutter-button__glyph {
  font-size: 44rpx;
  color: #333333;
  line-height: 1;
}

.dev-hint {
  margin-top: 24rpx;
  padding: 16rpx;
  align-self: center;
}

.dev-hint__text {
  font-size: 22rpx;
  color: #999999;
  text-decoration: underline;
}

.photograph-page__safe {
  /* 为原生 tabBar 预留高度（约 50px）+ 安全区 */
  height: calc(24rpx + 50px + env(safe-area-inset-bottom));
}
</style>
