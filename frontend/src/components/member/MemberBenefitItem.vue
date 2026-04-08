<template>
  <view class="member-benefit-item">
    <view class="member-benefit-item__icon">
      <image v-if="iconSrc" class="member-benefit-item__img" :src="iconSrc" mode="aspectFit" />
      <text v-else class="member-benefit-item__placeholder">{{ placeholderChar }}</text>
    </view>
    <view class="member-benefit-item__body">
      <text class="member-benefit-item__title">{{ title }}</text>
      <text class="member-benefit-item__desc">{{ desc }}</text>
    </view>
  </view>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  title: { type: String, required: true },
  desc: { type: String, default: '' },
  icon: { type: String, default: '' },
})

const iconSrc = computed(() => (props.icon && props.icon.trim() ? props.icon : ''))

const placeholderChar = computed(() => props.title.slice(0, 1) || '·')
</script>

<style lang="scss" scoped>
.member-benefit-item {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
  gap: 28rpx;
  width: 100%;
  padding: 36rpx;
  background: #fff9e6;
  border-radius: 32rpx;
  border: 2rpx solid #f5e6c8;
  box-sizing: border-box;
}

.member-benefit-item__icon {
  flex-shrink: 0;
  width: 160rpx;
  height: 160rpx;
  border-radius: 32rpx;
  background: #fff3e0;
  border: 2rpx solid #e8dcc8;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.member-benefit-item__img {
  width: 100%;
  height: 100%;
}

.member-benefit-item__placeholder {
  font-size: 48rpx;
  font-weight: 600;
  color: #c4956a;
}

.member-benefit-item__body {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 16rpx;
}

.member-benefit-item__title {
  font-size: 30rpx;
  font-weight: 600;
  color: #333333;
  line-height: 1.35;
}

.member-benefit-item__desc {
  font-size: 24rpx;
  color: #666666;
  line-height: 1.55;
}
</style>
