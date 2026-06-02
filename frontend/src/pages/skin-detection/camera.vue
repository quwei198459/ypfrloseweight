<template>
  <view class="camera-page">
    <view class="camera-shell">
      <camera
        v-if="!imagePath"
        class="camera-view"
        :device-position="devicePosition"
        flash="off"
        resolution="high"
        @error="onCameraError"
      />
      <image v-else class="camera-view" :src="imagePath" mode="aspectFill" />

      <view class="face-guide" pointer-events="none">
        <view class="corner corner--lt"></view>
        <view class="corner corner--rt"></view>
        <view class="corner corner--lb"></view>
        <view class="corner corner--rb"></view>
        <view class="face-mesh">
          <view class="mesh-line mesh-line--v1"></view>
          <view class="mesh-line mesh-line--v2"></view>
          <view class="mesh-line mesh-line--v3"></view>
          <view class="mesh-line mesh-line--h1"></view>
          <view class="mesh-line mesh-line--h2"></view>
          <view class="mesh-line mesh-line--h3"></view>
          <view class="mesh-line mesh-line--d1"></view>
          <view class="mesh-line mesh-line--d2"></view>
          <view class="mesh-line mesh-line--d3"></view>
          <view class="mesh-line mesh-line--d4"></view>
          <view class="mesh-line mesh-line--d5"></view>
          <view class="mesh-line mesh-line--d6"></view>
        </view>
      </view>

      <view v-if="!imagePath" class="camera-tip">
        <text class="camera-tip__title">请将面部置于轮廓内</text>
        <text class="camera-tip__desc">保持正脸、光线充足，额头和脸颊无遮挡</text>
      </view>
      <view v-else class="camera-tip camera-tip--preview">
        <text class="camera-tip__title">确认照片是否清晰</text>
        <text class="camera-tip__desc">如脸部不完整或光线较暗，请重新拍摄</text>
      </view>
    </view>

    <view class="bottom-panel">
      <view class="side-action" @click="imagePath ? retake() : goBack()">
        <text class="side-action__text">{{ imagePath ? '重拍' : '取消' }}</text>
      </view>

      <view v-if="!imagePath" class="shutter" @click="takePhoto">
        <view class="shutter__inner"></view>
      </view>
      <view v-else class="use-photo" @click="submit">
        <text class="use-photo__text">使用照片</text>
      </view>

      <view class="side-action side-action--right" @click="imagePath ? undefined : switchCamera()">
        <text v-if="!imagePath" class="side-action__icon">↻</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const STORAGE_IMAGE = 'skin_detection_image_path'
const imagePath = ref('')
const devicePosition = ref<'front' | 'back'>('front')

function saveImage(path: string) {
  imagePath.value = path
  uni.setStorageSync(STORAGE_IMAGE, path)
}

function chooseFromAlbum() {
  uni.chooseImage({
    count: 1,
    sizeType: ['compressed'],
    sourceType: ['album'],
    success: (res) => {
      const path = res.tempFilePaths?.[0]
      if (path) saveImage(path)
    },
    fail: () => {
      uni.showToast({ title: '未选择图片', icon: 'none' })
    },
  })
}

function takePhoto() {
  const ctx = uni.createCameraContext()
  ctx.takePhoto({
    quality: 'high',
    success: (res) => {
      if (res.tempImagePath) saveImage(res.tempImagePath)
    },
    fail: () => {
      uni.showToast({ title: '拍照失败，请检查相机权限', icon: 'none' })
    },
  })
}

function switchCamera() {
  devicePosition.value = devicePosition.value === 'front' ? 'back' : 'front'
}

function retake() {
  imagePath.value = ''
  uni.removeStorageSync(STORAGE_IMAGE)
}

function goBack() {
  uni.navigateBack()
}

function submit() {
  if (!imagePath.value) {
    uni.showToast({ title: '请先拍摄正脸照', icon: 'none' })
    return
  }
  uni.navigateTo({ url: '/pages/skin-detection/loading' })
}

function onCameraError() {
  uni.showToast({ title: '请允许使用相机权限', icon: 'none' })
}
</script>

<style lang="scss" scoped>
.camera-page {
  min-height: 100vh;
  background: #000;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.camera-shell {
  position: relative;
  flex: 1;
  min-height: 0;
  background: #000;
  overflow: hidden;
}

.camera-view {
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
}

.face-guide {
  position: absolute;
  left: 50%;
  top: 44%;
  width: 690rpx;
  height: 820rpx;
  transform: translate(-50%, -50%);
  z-index: 5;
}

.corner {
  position: absolute;
  width: 78rpx;
  height: 78rpx;
  border-color: rgba(255, 255, 255, 0.9);
  border-style: solid;
  z-index: 7;
}

.corner--lt {
  left: 0;
  top: 0;
  border-width: 8rpx 0 0 8rpx;
  border-radius: 10rpx 0 0 0;
}

.corner--rt {
  right: 0;
  top: 0;
  border-width: 8rpx 8rpx 0 0;
  border-radius: 0 10rpx 0 0;
}

.corner--lb {
  left: 0;
  bottom: 0;
  border-width: 0 0 8rpx 8rpx;
  border-radius: 0 0 0 10rpx;
}

.corner--rb {
  right: 0;
  bottom: 0;
  border-width: 0 8rpx 8rpx 0;
  border-radius: 0 0 10rpx 0;
}

.face-mesh {
  position: absolute;
  left: 50%;
  top: 48%;
  width: 590rpx;
  height: 650rpx;
  transform: translate(-50%, -50%);
  border-radius: 42% 42% 47% 47%;
  border: 4rpx solid rgba(255, 255, 255, 0.34);
  overflow: hidden;
  opacity: 0.95;
}

.face-mesh::before,
.face-mesh::after {
  content: '';
  position: absolute;
  left: 50%;
  top: 0;
  width: 4rpx;
  height: 100%;
  background: rgba(255, 255, 255, 0.36);
  transform: translateX(-50%);
}

.face-mesh::after {
  left: 0;
  top: 50%;
  width: 100%;
  height: 4rpx;
  transform: translateY(-50%);
}

.mesh-line {
  position: absolute;
  left: 50%;
  top: 50%;
  height: 3rpx;
  background: rgba(255, 255, 255, 0.3);
  transform-origin: center;
}

.mesh-line--v1,
.mesh-line--v2,
.mesh-line--v3 {
  top: 0;
  width: 3rpx;
  height: 100%;
  transform: none;
}

.mesh-line--v1 { left: 28%; }
.mesh-line--v2 { left: 50%; background: rgba(255, 255, 255, 0.44); }
.mesh-line--v3 { left: 72%; }

.mesh-line--h1,
.mesh-line--h2,
.mesh-line--h3 {
  left: 0;
  width: 100%;
  height: 3rpx;
  transform: none;
}

.mesh-line--h1 { top: 24%; }
.mesh-line--h2 { top: 50%; background: rgba(255, 255, 255, 0.44); }
.mesh-line--h3 { top: 74%; }

.mesh-line--d1 { width: 720rpx; transform: translate(-50%, -50%) rotate(34deg); }
.mesh-line--d2 { width: 720rpx; transform: translate(-50%, -50%) rotate(-34deg); }
.mesh-line--d3 { width: 560rpx; top: 30%; transform: translate(-50%, -50%) rotate(24deg); }
.mesh-line--d4 { width: 560rpx; top: 30%; transform: translate(-50%, -50%) rotate(-24deg); }
.mesh-line--d5 { width: 560rpx; top: 70%; transform: translate(-50%, -50%) rotate(24deg); }
.mesh-line--d6 { width: 560rpx; top: 70%; transform: translate(-50%, -50%) rotate(-24deg); }

.camera-tip {
  position: absolute;
  left: 48rpx;
  right: 48rpx;
  bottom: 44rpx;
  z-index: 8;
  padding: 20rpx 24rpx;
  border-radius: 24rpx;
  background: rgba(0, 0, 0, 0.34);
  backdrop-filter: blur(8px);
  text-align: center;
}

.camera-tip--preview {
  background: rgba(31, 42, 31, 0.58);
}

.camera-tip__title {
  display: block;
  font-size: 30rpx;
  font-weight: 800;
  color: #fff;
}

.camera-tip__desc {
  display: block;
  margin-top: 8rpx;
  font-size: 24rpx;
  line-height: 1.45;
  color: rgba(255, 255, 255, 0.82);
}

.bottom-panel {
  height: 240rpx;
  padding: 28rpx 40rpx calc(24rpx + env(safe-area-inset-bottom));
  box-sizing: border-box;
  background: #000;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.side-action {
  width: 140rpx;
  height: 96rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.side-action__text,
.side-action__icon {
  font-size: 30rpx;
  color: #fff;
}

.side-action__icon {
  width: 88rpx;
  height: 88rpx;
  border-radius: 44rpx;
  background: rgba(255, 255, 255, 0.16);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 44rpx;
  font-weight: 700;
}

.shutter {
  width: 132rpx;
  height: 132rpx;
  border-radius: 66rpx;
  border: 8rpx solid #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
}

.shutter__inner {
  width: 100rpx;
  height: 100rpx;
  border-radius: 50rpx;
  background: #fff;
}

.use-photo {
  min-width: 188rpx;
  height: 88rpx;
  padding: 0 32rpx;
  border-radius: 44rpx;
  background: #9ebc86;
  display: flex;
  align-items: center;
  justify-content: center;
}

.use-photo__text {
  font-size: 30rpx;
  font-weight: 800;
  color: #fff;
}
</style>
