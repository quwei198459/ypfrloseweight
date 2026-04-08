<template>
  <view class="top-header">
    <view class="top-header-row">
      <view class="back-btn" @click="handleBack">
        <text class="back-icon">{{ backChevron }}</text>
      </view>
      <text class="title">{{ title }}</text>
      <view class="capsule" v-if="showCapsule">
        <view class="dot dot-1" />
        <view class="dot dot-2" />
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
const backChevron = '<'

const props = defineProps<{
  title: string
  showCapsule?: boolean
}>()

const handleBack = () => {
  if (getCurrentPages().length > 1) {
    uni.navigateBack()
  } else {
    uni.switchTab({ url: '/pages/home/index' })
  }
}
</script>

<style scoped lang="scss">
.top-header {
  width: 100%;
  background: #c5dd97;
  border-radius: 12px;
  padding: 8px 16px 10px;
  box-sizing: border-box;
}

.top-header-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 32px;
}

.back-btn {
  width: 32px;
  height: 32px;
  border-radius: 16px;
  background: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
}

.back-icon {
  font-size: 18px;
  color: #5a7040;
}

.title {
  font-size: 16px;
  font-weight: 600;
  color: #1f2a1f;
}

.capsule {
  width: 80px;
  height: 32px;
  border-radius: 16px;
  background: #ddecc0;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
}

.dot {
  border-radius: 3px;
  background: #5a7040;
}
.dot-1 {
  width: 6px;
  height: 6px;
}
.dot-2 {
  width: 10px;
  height: 6px;
}
</style>

