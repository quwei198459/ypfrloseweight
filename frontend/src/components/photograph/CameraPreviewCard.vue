<template>
  <view class="preview-card">
    <view class="preview-card__inner">
      <!-- 媒体区：图片 + 各态叠加 -->
      <view class="preview-card__media">
        <image
          v-if="previewSrc"
          class="preview-image"
          :src="previewSrc"
          mode="aspectFill"
        />
        <view v-else class="preview-image preview-image--placeholder" />

        <view
          v-if="showIdleTip"
          class="tip-bar"
        >
          <text class="tip-bar__panda">🐼</text>
          <text class="tip-bar__text">俯拍且拍摄距离为20cm左右，识别更准确哦</text>
        </view>

        <view v-if="pageState === 'failed'" class="failed-toast">
          <view class="failed-toast__icon-wrap">
            <text class="failed-toast__icon-char">!</text>
          </view>
          <text class="failed-toast__text">识别失败，未检测到食物</text>
        </view>

        <!-- 成功态：卡片 + 热量模块叠在预览上 -->
        <view v-if="showSuccessOverlay" class="success-stack">
          <RecognitionFoodCard
            class="success-stack__card"
            :food-name="foodName"
            :gi-label="giLabel"
            :calories="calories"
            @edit="emit('edit-food')"
            @delete="emit('delete-food')"
          />
          <HeatSummaryModule
            class="success-stack__heat"
            :badge-percent-label="badgePercentLabel"
            :strip-text="stripText"
          />
        </view>
      </view>

      <!-- 识图过程：进度在图片区域下方（内联避免 mp 依赖分析把子组件当无引用文件忽略） -->
      <view v-show="showProcessing" class="preview-card__process">
        <view class="rp">
          <view class="rp__track">
            <view class="rp__fill" :style="{ width: processingFillPercent + '%' }" />
          </view>
          <text class="rp__label">{{ processingLabel }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import HeatSummaryModule from './HeatSummaryModule.vue'
import RecognitionFoodCard from './RecognitionFoodCard.vue'

export type PreviewCardState =
  | 'idle'
  | 'uploading'
  | 'recognizing_type'
  | 'recognizing_weight'
  | 'success'
  | 'mealtype_dropdown_open'
  | 'editing_calorie'
  | 'adjusting_ratio'
  | 'failed'
  | 'saved'

const props = withDefaults(
  defineProps<{
    pageState: PreviewCardState
    previewSrc: string
    processingLabel?: string
    processingFillPercent?: number
    foodName?: string
    giLabel?: string
    calories?: number
    badgePercentLabel?: string
    stripText?: string
  }>(),
  {
    previewSrc: '',
    processingLabel: '',
    processingFillPercent: 0,
    foodName: '',
    giLabel: '低 GI',
    calories: 0,
    badgePercentLabel: '100%',
    stripText: '',
  },
)

const emit = defineEmits<{
  (e: 'edit-food'): void
  (e: 'delete-food'): void
}>()

const showIdleTip = computed(() => {
  return (
    props.pageState === 'idle' &&
    !props.previewSrc
  )
})

const showProcessing = computed(() => {
  return (
    props.pageState === 'uploading' ||
    props.pageState === 'recognizing_type' ||
    props.pageState === 'recognizing_weight'
  )
})

const showSuccessOverlay = computed(() => {
  return (
    props.pageState === 'success' ||
    props.pageState === 'mealtype_dropdown_open' ||
    props.pageState === 'editing_calorie' ||
    props.pageState === 'adjusting_ratio'
  )
})
</script>

<style lang="scss" scoped>
.preview-card {
  width: 100%;
}

.preview-card__inner {
  position: relative;
  width: 100%;
  border-radius: 24rpx;
  overflow: hidden;
  background: #d8d8d8;
  border: 1rpx solid #cccccc;
  box-sizing: border-box;
}

.preview-card__media {
  position: relative;
  width: 100%;
  min-height: 720rpx;
  overflow: hidden;
}

.preview-image {
  width: 100%;
  height: 720rpx;
  display: block;
}

.preview-image--placeholder {
  background: #d8d8d8;
}

.tip-bar {
  position: absolute;
  left: 24rpx;
  right: 24rpx;
  bottom: 24rpx;
  min-height: 96rpx;
  padding: 16rpx 24rpx 16rpx 20rpx;
  box-sizing: border-box;
  border-radius: 48rpx;
  background: #e3f2e0;
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 12rpx;
  z-index: 5;
}

.tip-bar__panda {
  font-size: 36rpx;
  line-height: 1;
  flex-shrink: 0;
}

.tip-bar__text {
  flex: 1;
  font-size: 22rpx;
  line-height: 1.45;
  color: #333333;
}

.failed-toast {
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
  z-index: 8;
  max-width: 86%;
  padding: 20rpx 28rpx;
  border-radius: 16rpx;
  background: #4a4a4a;
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 12rpx;
  box-sizing: border-box;
}

.failed-toast__icon-wrap {
  width: 36rpx;
  height: 36rpx;
  border-radius: 18rpx;
  background: rgba(255, 255, 255, 0.95);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.failed-toast__icon-char {
  font-size: 22rpx;
  font-weight: 800;
  color: #4a4a4a;
  line-height: 1;
}

.failed-toast__text {
  font-size: 24rpx;
  color: #f5f5f5;
  line-height: 1.4;
}

.success-stack {
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  z-index: 6;
  pointer-events: none;
}

.success-stack__card {
  position: absolute;
  left: 50%;
  top: 200rpx;
  transform: translateX(-50%);
  pointer-events: auto;
}

.success-stack__heat {
  position: absolute;
  left: 16rpx;
  right: 16rpx;
  bottom: 48rpx;
  pointer-events: none;
}

.preview-card__process {
  padding: 20rpx 8rpx 24rpx;
  background: #d8d8d8;
  border-top: 1rpx solid #c8c8c8;
  box-sizing: border-box;
}

.rp {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 12rpx;
  align-items: flex-start;
  box-sizing: border-box;
  padding: 0 4rpx;
}

.rp__track {
  width: 100%;
  height: 16rpx;
  border-radius: 8rpx;
  background: #c8e6c9;
  overflow: hidden;
  box-sizing: border-box;
}

.rp__fill {
  height: 100%;
  border-radius: 8rpx;
  background: #2e7d32;
  min-width: 8rpx;
  transition: width 0.35s ease-out;
}

.rp__label {
  font-size: 24rpx;
  color: #333333;
  line-height: 1.4;
}
</style>
