<template>
  <view
    class="preview-card"
    :class="{ 'preview-card--success': showSuccessOverlay }"
  >
    <view class="preview-card__inner">
      <!-- 媒体区：图片 + 各态叠加 -->
      <view class="preview-card__media">
        <!-- #ifdef MP-WEIXIN -->
        <camera
          v-if="showEmbeddedCamera"
          id="lwCamera"
          class="preview-live-camera"
          device-position="back"
          flash="off"
          @error="onLiveCameraError"
          @initdone="onCameraInitDone"
        />
        <!-- #endif -->
        <image
          v-if="previewSrc"
          class="preview-image preview-image--layer"
          :src="previewSrc"
          mode="aspectFill"
        />
        <view
          v-else-if="showPlaceholder"
          class="preview-image preview-image--placeholder"
        />

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

        <!-- 成功态：只保留总热量模块叠在预览上 -->
        <view v-if="showSuccessOverlay" class="success-stack">
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
import { computed, getCurrentInstance, nextTick, onMounted, ref, watch } from 'vue'
import HeatSummaryModule from './HeatSummaryModule.vue'

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

const showEmbeddedCamera = computed(() => {
  let ok = false
  // #ifdef MP-WEIXIN
  ok = props.pageState === 'idle' && !props.previewSrc
  // #endif
  return ok
})

/** 微信 camera 在 init 完成前 takePhoto 会失败（如 operateCamera:fail camera has not been initialized） */
const cameraInitDone = ref(false)
// eslint-disable-next-line @typescript-eslint/no-explicit-any
let componentOwner: any

onMounted(() => {
  componentOwner = getCurrentInstance()?.proxy
})

watch(showEmbeddedCamera, (on) => {
  if (on) {
    cameraInitDone.value = false
  }
})

function onCameraInitDone() {
  cameraInitDone.value = true
}

const showPlaceholder = computed(
  () => !props.previewSrc && !showEmbeddedCamera.value,
)

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

function onLiveCameraError() {
  uni.showToast({ title: '相机启动失败，可改用系统相机', icon: 'none', duration: 2000 })
}

async function waitCameraReady(maxMs: number): Promise<void> {
  const t0 = Date.now()
  while (Date.now() - t0 < maxMs) {
    if (cameraInitDone.value) return
    await new Promise<void>((r) => setTimeout(r, 40))
  }
}

function createWxCameraContext() {
  const owner = componentOwner
  // 自定义组件内 camera：必须带组件实例；仅 id 在部分基础库/模拟器上 takePhoto 会失败
  if (owner) {
    return uni.createCameraContext('lwCamera', owner)
  }
  return uni.createCameraContext('lwCamera')
}

/** 微信小程序内嵌相机拍照；失败返回 undefined，由页面降级 chooseImage（模拟器常无真机相机） */
async function takeLivePhoto(): Promise<string | undefined> {
  // #ifdef MP-WEIXIN
  if (!showEmbeddedCamera.value) {
    return undefined
  }
  await nextTick()
  await waitCameraReady(2800)

  if (!showEmbeddedCamera.value) {
    return undefined
  }

  const shootOnce = () =>
    new Promise<string | undefined>((resolve) => {
      try {
        const ctx = createWxCameraContext()
        ctx.takePhoto({
          quality: 'normal',
          success: (res) => resolve(res.tempImagePath || undefined),
          fail: () => resolve(undefined),
        })
      } catch {
        resolve(undefined)
      }
    })

  let path = await shootOnce()
  if (!path) {
    await new Promise<void>((r) => setTimeout(r, 160))
    path = await shootOnce()
  }
  return path || undefined
  // #endif
  // #ifndef MP-WEIXIN
  return undefined
  // #endif
}

defineExpose({ takeLivePhoto })
</script>

<style lang="scss" scoped>
.preview-card {
  width: 100%;
  height: 100%;
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
}

.preview-card__inner {
  position: relative;
  width: 100%;
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
  border-radius: 24rpx;
  overflow: hidden;
  background: #d8d8d8;
  border: 1rpx solid #cccccc;
  box-sizing: border-box;
}

.preview-card__media {
  position: relative;
  width: 100%;
  flex: 1;
  /* 尽量占满导航与快门之间的区域，减少预览下方留白 */
  min-height: 72vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.preview-card--success .preview-card__media {
  min-height: 0;
  height: 100%;
}

.preview-live-camera {
  position: absolute;
  left: 0;
  top: 0;
  right: 0;
  bottom: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
}

.preview-image {
  flex: 1;
  width: 100%;
  min-height: 72vh;
  display: block;
}

.preview-card--success .preview-image {
  min-height: 0;
  height: 100%;
}

.preview-image--layer {
  position: relative;
  z-index: 2;
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

.success-stack__heat {
  position: absolute;
  left: 16rpx;
  right: 16rpx;
  bottom: 48rpx;
  pointer-events: none;
}

.preview-card__process {
  flex-shrink: 0;
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
