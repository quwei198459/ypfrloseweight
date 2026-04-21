<template>
  <view class="food-result-item" @click="emit('select', food)">
    <view class="food-image">
      <text v-if="useEmoji" class="food-emoji">{{ foodEmoji }}</text>
      <image
        v-else
        class="food-image-img"
        :src="imgSrc"
        mode="aspectFill"
        @error="onImgErr"
      />
    </view>
    <view class="food-info">
      <text class="food-name">{{ food.name }}</text>
      <text class="food-calorie-text">{{ food.calorie }} {{ food.unit }}</text>
    </view>
    <view v-if="food.giLevel" class="gi-tag" :class="'gi-' + food.giLevel">
      <text class="gi-tag-text">{{ giLabel }}</text>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { FOOD_IMAGE_PLACEHOLDER } from '@/constants/foodImage'
import type { SearchFoodItem } from '@/types/searchFood'

const props = defineProps<{
  food: SearchFoodItem
}>()

const imgBroken = ref(false)
watch(
  () => props.food.id,
  () => {
    imgBroken.value = false
  }
)

const imgSrc = computed(() => {
  if (imgBroken.value) return FOOD_IMAGE_PLACEHOLDER
  const u = (props.food.image || '').trim()
  return u || FOOD_IMAGE_PLACEHOLDER
})

/** 占位图与常量路径一致时用 emoji，避免与缩略图重复一块色 */
const useEmoji = computed(() => {
  const u = (props.food.image || '').trim()
  return !u || imgBroken.value
})

function onImgErr() {
  imgBroken.value = true
}

const emit = defineEmits<{
  (e: 'select', food: SearchFoodItem): void
}>()

const foodEmoji = computed(() => {
  const n = props.food.name
  if (/橙|柑|桔|橘|柚|柠|檬/.test(n)) return '🍊'
  if (/果|瓜|莓|桃|梨|蕉|果/.test(n)) return '🍊'
  if (/糖|冻|罐头|汁|酱|汽水/.test(n)) return '🍬'
  return '🍽'
})

const giLabel = computed(() => {
  const lv = props.food.giLevel
  if (!lv) return ''
  const m: Record<string, string> = { low: '低Gi', medium: '中Gi', high: '高Gi' }
  return m[lv] || 'Gi'
})
</script>

<style lang="scss" scoped>
/* 设计稿 food-result-item：圆角 14、padding 12、gap 10、图 48、描边 #E8E8E8 */
.food-result-item {
  display: flex;
  flex-direction: row;
  align-items: center;
  padding: 24rpx;
  background: #ffffff;
  border-radius: 28rpx;
  margin-bottom: 20rpx;
  border: 1rpx solid #e8e8e8;
  box-sizing: border-box;
  gap: 20rpx;
}

.food-image {
  width: 96rpx;
  height: 96rpx;
  border-radius: 16rpx;
  background: #fff8e1;
  flex-shrink: 0;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}

.food-image-img {
  width: 100%;
  height: 100%;
}

.food-emoji {
  font-size: 40rpx;
  line-height: 1;
}

.food-info {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 8rpx;
}

.food-name {
  font-size: 30rpx;
  font-weight: 600;
  color: #212121;
}

.food-calorie-text {
  font-size: 24rpx;
  color: #689f38;
}

.gi-tag {
  flex-shrink: 0;
  padding: 8rpx 16rpx;
  border-radius: 12rpx;
}

.gi-tag-text {
  font-size: 22rpx;
  font-weight: normal;
}

.gi-low {
  background: #e8f5e9;
}
.gi-low .gi-tag-text {
  color: #2e7d32;
}

.gi-medium {
  background: #fff3e0;
}
.gi-medium .gi-tag-text {
  color: #e65100;
}

.gi-high {
  background: #ffebee;
}
.gi-high .gi-tag-text {
  color: #c62828;
}
</style>
