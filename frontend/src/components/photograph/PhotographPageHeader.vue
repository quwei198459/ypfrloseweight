<template>
  <view class="ph-header">
    <view class="ph-header__title-row">
      <text class="ph-header__title">餐前拍一拍</text>
    </view>
    <view v-if="showSubtitle" class="ph-header__sub-row">
      <text class="ph-header__subtitle">{{ mealLabel }} · 识图结果</text>
    </view>
  </view>
</template>

<script setup lang="ts">
withDefaults(
  defineProps<{
    showSubtitle?: boolean
    mealLabel?: string
  }>(),
  {
    showSubtitle: false,
    mealLabel: '晚餐',
  },
)
</script>

<style lang="scss" scoped>
.ph-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8rpx;
  margin-bottom: 8rpx;
}

.ph-header__title-row {
  min-height: 88rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.ph-header__title {
  font-size: 34rpx;
  font-weight: 600;
  color: #1a1a1a;
  line-height: 1.3;
}

.ph-header__sub-row {
  min-height: 36rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.ph-header__subtitle {
  font-size: 24rpx;
  color: #666666;
  line-height: 1.3;
}
</style>
