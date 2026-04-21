<template>
  <view class="photograph-page">
    <view class="photograph-page__body">
      <PhotographPageHeader
        :show-main-title="false"
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
          ref="cameraPreviewRef"
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

      <!-- 成功态底栏：三个同规格按钮 -->
      <view
        v-if="phase === 'success' || phase === 'mealtype_dropdown_open'"
        class="success-bot"
      >
        <view class="success-bot__btn success-bot__btn--cancel" @click="onCancelRecognizeResult">
          <text class="success-bot__t success-bot__t--cancel">取消</text>
        </view>
        <view class="success-bot__btn success-bot__btn--ghost" @click="openRatioSheet">
          <text class="success-bot__t success-bot__t--ghost">食物比例调节</text>
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
import { onShow } from '@dcloudio/uni-app'
import { computed, ref } from 'vue'
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

const cameraPreviewRef = ref<{
  takeLivePhoto: () => Promise<string | undefined>
} | null>(null)

onShow(() => {
  // #ifdef MP-WEIXIN
  uni.authorize({
    scope: 'scope.camera',
    fail() {
      /* 用户拒绝时仍可用相册；快门会降级 chooseImage */
    },
  })
  // #endif
})

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
  resetToIdle,
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

/** 放弃当前识图结果，回到拍照界面 */
function onCancelRecognizeResult() {
  closeMealDropdown()
  resetToIdle()
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
  void takePhotoOrChooseCamera()
}

function chooseCameraImage(): Promise<string | undefined> {
  return new Promise((resolve) => {
    uni.chooseImage({
      count: 1,
      sourceType: ['camera'],
      success: (res) => resolve(res.tempFilePaths[0]),
      fail: () => resolve(undefined),
    })
  })
}

async function takePhotoOrChooseCamera() {
  // #ifdef MP-WEIXIN
  if (phase.value === 'idle' && !previewSrc.value) {
    uni.showLoading({ title: '拍照中', mask: true })
    try {
      let p = await cameraPreviewRef.value?.takeLivePhoto()
      // 开发者工具/部分机型内嵌 takePhoto 失败时，降级系统相机，仍走同一套上传与识图接口
      if (!p) {
        p = await chooseCameraImage()
      }
      if (p) {
        handleImagePicked(p, { source: 'camera' })
        return
      }
      uni.showToast({ title: '拍照失败，请使用相册', icon: 'none' })
    } finally {
      uni.hideLoading()
    }
    return
  }
  // #endif
  const p = await chooseCameraImage()
  if (p) {
    handleImagePicked(p, { source: 'camera' })
  }
}

function setRatioPercent(v: number) {
  ratioPercent.value = v
}
</script>

<style lang="scss" scoped>
.photograph-page {
  /* 固定高度便于子项 flex:1 在小程序里正确分配剩余空间，减少预览与快门间大块留白 */
  height: 100vh;
  min-height: 100vh;
  background: #f7f8f7;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
}

.photograph-page__body {
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
  padding: 0 32rpx 0;
  box-sizing: border-box;
  position: relative;
}

.photograph-page__preview-wrap {
  position: relative;
  flex: 1;
  min-height: 0;
  height: 0;
  display: flex;
  flex-direction: column;
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
  align-items: stretch;
  justify-content: space-between;
  flex-shrink: 0;
  gap: 12rpx;
  margin-top: 24rpx;
  padding: 0 8rpx 24rpx;
  box-sizing: border-box;
}

.success-bot__btn {
  flex: 1;
  min-width: 0;
  min-height: 88rpx;
  padding: 12rpx 8rpx;
  border-radius: 44rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
}

.success-bot__btn--cancel {
  background: #ffffff;
  border: 2rpx solid #c8c8c8;
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
  font-size: 24rpx;
  font-weight: 600;
  text-align: center;
  line-height: 1.35;
}

.success-bot__t--cancel {
  color: #555555;
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
  align-items: center;
  justify-content: space-between;
  flex-shrink: 0;
  margin-top: 8rpx;
  padding: 0 8rpx 8rpx;
}

.action-row__left {
  width: 180rpx;
  padding-left: 40rpx;
  box-sizing: border-box;
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
  width: 140rpx;
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
  width: 176rpx;
  height: 176rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.shutter-button__outer {
  position: absolute;
  left: 0;
  top: 0;
  width: 176rpx;
  height: 176rpx;
  border-radius: 88rpx;
  background: #bfd9a3;
  border: 2rpx solid #9ebc86;
  box-sizing: border-box;
}

.shutter-button__inner {
  position: relative;
  z-index: 1;
  width: 136rpx;
  height: 136rpx;
  border-radius: 68rpx;
  background: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2rpx 8rpx rgba(0, 0, 0, 0.06);
}

.shutter-button__glyph {
  display: block;
  width: 100%;
  font-size: 82rpx;
  color: #333333;
  line-height: 1;
  text-align: center;
  /* emoji 字形偏上，略压底边距后视觉更居中 */
  margin-bottom: 25rpx;
}

.photograph-page__safe {
  /* 异形屏安全区 + 与原生 tabBar 的缓冲，避免 Android / iPhone X 系列贴边 */
  flex-shrink: 0;
  height: calc(16rpx + env(safe-area-inset-bottom));
}
</style>
