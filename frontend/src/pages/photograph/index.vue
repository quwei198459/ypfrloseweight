<template>
  <view class="photograph-page">
    <view class="photograph-page__body">
      <PhotographPageHeader
        :show-main-title="false"
        :show-subtitle="showHeaderSubtitle"
        :meal-label="mealLabel"
      />

      <view
        v-if="showMealRow"
        class="meal-anchor"
        :class="{ 'meal-anchor--compact': isSuccessMealCompact }"
      >
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

      <scroll-view
        v-if="phase === 'success' || phase === 'mealtype_dropdown_open'"
        scroll-y
        class="success-scroll"
      >
        <view class="success-scroll__inner">
          <view class="success-photo">
            <image
              v-if="previewSrc"
              class="success-photo__image"
              :src="previewSrc"
              mode="aspectFill"
            />
            <view v-else class="success-photo__placeholder" />
            <HeatSummaryModule
              class="success-photo__heat"
              :badge-percent-label="recommendedPercentLabel"
              :strip-text="totalStripText"
            />
          </view>

          <view class="food-list">
            <RecognitionFoodListItem
              v-for="food in mockResult.foods"
              :key="food.lineId"
              :food-name="food.foodName"
              :gi-label="food.giLabel"
              :gi="food.gi"
              :calories="getFoodDisplayedCalories(food)"
              :quantity-label="getFoodQuantityLabel(food)"
              @edit="openCalorieEdit(food.lineId)"
              @delete="deleteFood(food.lineId)"
            />
            <view v-if="mockResult.foods.length === 0" class="food-list__empty">
              <text class="food-list__empty-text">暂无食物，请重新拍照或取消本次识别</text>
            </view>
          </view>
        </view>
      </scroll-view>

      <view v-else class="photograph-page__preview-wrap">
        <CameraPreviewCard
          ref="cameraPreviewRef"
          :page-state="phase"
          :preview-src="previewSrc"
          :processing-label="processingLabel"
          :processing-fill-percent="processingFillPercent"
          :badge-percent-label="recommendedPercentLabel"
          :strip-text="totalStripText"
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

      <view v-if="accessPanelVisible" class="service-panel" @click="hideContactPanel">
        <view class="service-panel__card" @click.stop>
          <view class="service-panel__title">
            {{ accessInfo?.reason === 'quota_exhausted' ? '拍照识别次数已用完' : '暂未开通拍照识别' }}
          </view>
          <view class="service-panel__desc">
            {{ accessInfo?.message || '当前手机号暂未开通拍照识别，请联系客服开通。其它功能不受影响。' }}
          </view>
          <view class="service-panel__qr">
            <image
              v-if="accessInfo && makeQrSrc(accessInfo)"
              :src="makeQrSrc(accessInfo)"
              mode="aspectFit"
              class="service-panel__qr-img"
            />
            <view v-else class="service-panel__qr-empty">暂无二维码</view>
          </view>
          <view class="service-panel__meta">
            <view>客服电话：{{ accessInfo?.servicePhone || '400-000-0000' }}</view>
            <view>客服微信：{{ accessInfo?.serviceWechat || 'baohu-service' }}</view>
          </view>
          <view class="service-panel__actions">
            <view class="service-panel__btn service-panel__btn--ghost" @click="onAccessAction('phone')">拨打客服电话</view>
            <view class="service-panel__btn service-panel__btn--solid" @click="onAccessAction('wechat')">复制微信号</view>
          </view>
          <view class="service-panel__close" @click="hideContactPanel">关闭</view>
        </view>
      </view>

    </view>

    <view
      v-if="phase === 'mealtype_dropdown_open'"
      class="page-dim"
      @click="closeMealDropdown"
    />

    <CalorieEditModal
      v-if="phase === 'editing_calorie'"
      v-model="quantityDraft"
      v-model:food-name="foodNameDraft"
      :unit-label="editingFood?.quantityUnit || 'g/ml'"
      :estimated-calories="editingFoodEstimatedCalories"
      @confirm="confirmCalorieEdit"
      @cancel="cancelCalorieEdit"
    />

    <RatioAdjustSheet
      v-if="phase === 'adjusting_ratio'"
      :foods="mockResult.foods"
      :ratio-percent-map="ratioPercentMap"
      :summary-text="ratioSummaryText"
      :meal-short-label="mealLabel"
      :get-displayed-calories="getDisplayedCaloriesByLineId"
      @update-food-ratio="setFoodRatioPercent"
      @close="closeRatioSheet"
      @add="onAddFromSheet"
    />

    <PhotographSavedOverlay v-if="phase === 'saved'" />

    <view
      v-if="phase === 'failed'"
      class="photograph-page__safe"
    />
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
import RecognitionFoodListItem from '@/components/photograph/RecognitionFoodListItem.vue'
import HeatSummaryModule from '@/components/photograph/HeatSummaryModule.vue'
import { usePhotographFlow } from '@/composables/usePhotographFlow'
import { API_BASE_URL } from '@/config/api'
import { checkMealPhotoAccess, type PhotoRecognitionAccessVo } from '@/api/recognize'
import type { MealTypeKey } from '@/types/photograph'

const cameraPreviewRef = ref<{
  takeLivePhoto: () => Promise<string | undefined>
} | null>(null)

const accessChecking = ref(false)
const accessPanelVisible = ref(false)
const accessInfo = ref<PhotoRecognitionAccessVo | null>(null)

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
  quantityDraft,
  foodNameDraft,
  editingFood,
  editingFoodEstimatedCalories,
  ratioPercentMap,
  mealLabel,
  processingFillPercent,
  processingLabel,
  recommendedPercentLabel,
  totalStripText,
  ratioSummaryText,
  isProcessing,
  getFoodDisplayedCalories,
  getFoodQuantityLabel,
  handleImagePicked,
  openMealDropdown,
  closeMealDropdown,
  selectMealType,
  openCalorieEdit,
  confirmCalorieEdit,
  cancelCalorieEdit,
  deleteFood,
  setFoodRatioPercent,
  openRatioSheet,
  closeRatioSheet,
  onConfirmMain,
  onAddFromSheet,
  onContinuePhoto,
  onExitPhoto,
  resetToIdle,
} = usePhotographFlow()

const showHeaderSubtitle = computed(() => {
  return phase.value === 'editing_calorie' || phase.value === 'adjusting_ratio'
})

const showMealRow = computed(() => {
  if (phase.value === 'idle' || phase.value === 'failed' || phase.value === 'saved') {
    return false
  }
  return true
})

const isSuccessMealCompact = computed(() => {
  return phase.value === 'success' || phase.value === 'mealtype_dropdown_open'
})

function onMealTriggerClick() {
  if (phase.value === 'success') {
    openMealDropdown()
  }
}

function onSelectMeal(key: MealTypeKey) {
  selectMealType(key)
}

function getDisplayedCaloriesByLineId(lineId: string) {
  const food = mockResult.value.foods.find((f) => f.lineId === lineId)
  return food ? getFoodDisplayedCalories(food) : 0
}

function showPhoneBindGuide() {
  uni.showModal({
    title: '请先绑定手机号',
    content: '使用拍照识别热量前，需要先绑定手机号，其它功能可继续正常使用。',
    confirmText: '去绑定',
    cancelText: '暂不用',
    success: (res) => {
      if (!res.confirm) return
      uni.navigateTo({
        url: '/pages/user/account-edit',
      })
    },
  })
}

function showContactPanel(access: PhotoRecognitionAccessVo) {
  accessInfo.value = access
  accessPanelVisible.value = true
}

function hideContactPanel() {
  accessPanelVisible.value = false
}

function makeQrSrc(access: PhotoRecognitionAccessVo) {
  const raw = access.serviceQrImageUrl || access.serviceQrImagePath || ''
  if (!raw) return ''
  if (/^https?:\/\//i.test(raw)) return raw
  if (raw.startsWith('/')) return `${API_BASE_URL}${raw}`
  return `${API_BASE_URL}/${raw}`
}

function dialServicePhone() {
  const phone = accessInfo.value?.servicePhone || '400-000-0000'
  uni.makePhoneCall({ phoneNumber: phone })
}

function copyServiceWechat() {
  const wechat = accessInfo.value?.serviceWechat || 'baohu-service'
  uni.setClipboardData({
    data: wechat,
    success: () => {
      uni.showToast({ title: '微信号已复制', icon: 'none' })
    },
  })
}

function onAccessAction(action: 'phone' | 'wechat') {
  if (action === 'phone') dialServicePhone()
  else copyServiceWechat()
}

function showContactGuide(access: PhotoRecognitionAccessVo) {
  showContactPanel(access)
}

async function ensurePhotoRecognitionAccess(): Promise<boolean> {
  if (accessChecking.value) return false
  accessChecking.value = true
  try {
    const access = await checkMealPhotoAccess()
    if (access.allowed) {
      accessPanelVisible.value = false
      return true
    }
    if (access.reason === 'phone_required' || !access.phoneBound) {
      showPhoneBindGuide()
      return false
    }
    showContactGuide(access)
    return false
  } catch (e) {
    const msg = e instanceof Error ? e.message : '权限校验失败'
    uni.showToast({ title: msg, icon: 'none' })
    return false
  } finally {
    accessChecking.value = false
  }
}

/** 放弃当前识图结果，回到拍照界面 */
function onCancelRecognizeResult() {
  closeMealDropdown()
  resetToIdle()
}

async function openAlbum() {
  if (isProcessing.value) return
  if (!(await ensurePhotoRecognitionAccess())) return
  uni.chooseImage({
    count: 1,
    sourceType: ['album'],
    success: (res) => {
      const p = res.tempFilePaths[0]
      handleImagePicked(p, { source: 'album' })
    },
  })
}

async function openCamera() {
  if (isProcessing.value) return
  if (!(await ensurePhotoRecognitionAccess())) return
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

.success-scroll {
  flex: 1;
  min-height: 0;
  height: 0;
}

.success-scroll__inner {
  display: flex;
  flex-direction: column;
  gap: 10rpx;
  padding-bottom: 12rpx;
  box-sizing: border-box;
}

.success-photo {
  position: relative;
  width: 100%;
  height: 500rpx;
  flex-shrink: 0;
  border-radius: 24rpx;
  overflow: hidden;
  background: #eeeeee;
  border: 1rpx solid #dddddd;
  box-sizing: border-box;
}

.success-photo__image,
.success-photo__placeholder {
  width: 100%;
  height: 100%;
  display: block;
}

.success-photo__placeholder {
  background: #eeeeee;
}

.success-photo__heat {
  position: absolute;
  left: 16rpx;
  right: 16rpx;
  bottom: 24rpx;
  z-index: 2;
  pointer-events: none;
}

.food-list {
  display: flex;
  flex-direction: column;
  gap: 18rpx;
  padding-bottom: 8rpx;
}

.food-list__empty {
  min-height: 160rpx;
  border-radius: 28rpx;
  border: 1rpx dashed #d0d8ca;
  background: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24rpx;
  box-sizing: border-box;
}

.food-list__empty-text {
  font-size: 26rpx;
  color: #888888;
  line-height: 1.45;
  text-align: center;
}

.meal-anchor {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  z-index: 120;
}

.meal-anchor--compact {
  position: relative;
  left: auto;
  top: auto;
  transform: none;
  margin-top: 4rpx;
  margin-bottom: 8rpx;
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
  margin-top: 12rpx;
  padding: 0 8rpx 10rpx;
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

.service-panel {
  position: fixed;
  inset: 0;
  z-index: 1000;
  background: rgba(15, 45, 40, 0.46);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 28rpx;
  box-sizing: border-box;
}

.service-panel__card {
  width: 100%;
  max-width: 620rpx;
  background: #fff;
  border-radius: 32rpx;
  padding: 28rpx;
  box-sizing: border-box;
}

.service-panel__title {
  font-size: 34rpx;
  font-weight: 700;
  color: #15302b;
}

.service-panel__desc {
  margin-top: 12rpx;
  font-size: 26rpx;
  line-height: 1.7;
  color: #5f6f67;
}

.service-panel__qr {
  margin-top: 22rpx;
  min-height: 360rpx;
  border-radius: 24rpx;
  background: #f8faf8;
  border: 1rpx solid #e2ebe5;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.service-panel__qr-img {
  width: 100%;
  height: 360rpx;
}

.service-panel__qr-empty {
  font-size: 24rpx;
  color: #94a39a;
}

.service-panel__meta {
  margin-top: 18rpx;
  font-size: 24rpx;
  color: #6a7c73;
  line-height: 1.8;
}

.service-panel__actions {
  display: flex;
  gap: 16rpx;
  margin-top: 20rpx;
}

.service-panel__btn {
  flex: 1;
  text-align: center;
  border-radius: 999rpx;
  height: 80rpx;
  line-height: 80rpx;
  font-size: 28rpx;
  font-weight: 600;
}

.service-panel__btn--ghost {
  background: #eef4ef;
  color: #325a4f;
}

.service-panel__btn--solid {
  background: linear-gradient(135deg, #79c791 0%, #5fa854 100%);
  color: #fff;
}

.service-panel__close {
  margin-top: 18rpx;
  text-align: center;
  font-size: 24rpx;
  color: #8a998f;
}

.photograph-page__safe {
  /* 异形屏安全区 + 与原生 tabBar 的缓冲，避免 Android / iPhone X 系列贴边 */
  flex-shrink: 0;
  height: calc(16rpx + env(safe-area-inset-bottom));
}
</style>
