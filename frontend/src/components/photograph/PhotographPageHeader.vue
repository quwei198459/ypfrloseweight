<template>
  <view v-if="showMainTitle || showSubtitle" class="ph-header">
    <view v-if="showMainTitle" class="ph-header__title-row">
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
    /** 为 false 时不展示大标题（与小程序 navigationBarTitleText 重复时可关） */
    showMainTitle?: boolean
    showSubtitle?: boolean
    mealLabel?: string
  }>(),
  {
    showMainTitle: true,
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
