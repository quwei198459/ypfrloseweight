<template>
  <view class="nutrition-comment-section">
    <text class="section-title">营养师评语</text>
    <text class="advantage-text">优点：桔子富含维生素C和膳食纤维，能增强免疫力促进消化，还能补充水分呢！</text>
    <text class="disadvantage-text">缺点：桔子含糖量较高，空腹吃可能会刺激胃部，而且营养不够全面哦。</text>
    <text class="next-meal-advice-text">下一顿饮食建议：明早可以搭配全麦面包煮鸡蛋和牛奶，营养更均衡。</text>
  </view>
</template>

<script setup lang="ts">
</script>

<style lang="scss" scoped>
.nutrition-comment-section {
  padding: 8rpx 8rpx 16rpx;
  display: flex;
  flex-direction: column;
  gap: 20rpx;
}

.section-title {
  font-size: 32rpx;
  font-weight: 600;
  color: #333333;
}

.advantage-text,
.disadvantage-text,
.next-meal-advice-text {
  font-size: 24rpx;
  line-height: 1.35;
  color: #424242;
}
</style>
