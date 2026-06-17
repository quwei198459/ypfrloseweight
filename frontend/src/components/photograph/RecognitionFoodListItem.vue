<template>
  <view class="fl-item">
    <view v-if="giBadgeText" class="fl-item__gi" :class="giLevelClass">
      <text class="fl-item__gi-text">{{ giBadgeText }}</text>
    </view>

    <view class="fl-item__main" @click="emit('edit')">
      <text class="fl-item__name">{{ foodName }}</text>
      <text class="fl-item__kcal">{{ quantityLabel }} · {{ calories }} 千卡</text>
    </view>

    <view class="fl-item__actions">
      <view class="fl-item__edit" @click.stop="emit('edit')">
        <text class="fl-item__edit-text">✎</text>
      </view>
      <view class="fl-item__delete" @click.stop="emit('delete')">
        <text class="fl-item__delete-text">×</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  foodName: string
  calories: number
  quantityLabel: string
  giLabel?: string
  /** 第三方返回的真实 GI 数值 */
  gi?: number
}>()

const emit = defineEmits<{
  (e: 'edit'): void
  (e: 'delete'): void
}>()

const hasGiValue = computed(() => typeof props.gi === 'number' && Number.isFinite(props.gi))

const giLevel = computed<'low' | 'mid' | 'high' | ''>(() => {
  if (hasGiValue.value) {
    const v = props.gi as number
    if (v <= 55) return 'low'
    if (v <= 69) return 'mid'
    return 'high'
  }
  const label = props.giLabel ?? ''
  if (label.includes('高')) return 'high'
  if (label.includes('中')) return 'mid'
  if (label.includes('低')) return 'low'
  return ''
})

const giLevelWord = computed(() => {
  switch (giLevel.value) {
    case 'low':
      return '低'
    case 'mid':
      return '中'
    case 'high':
      return '高'
    default:
      return ''
  }
})

/** 优先展示第三方真实 GI 数值，缺失时回退到分级文案 */
const giBadgeText = computed(() => {
  if (hasGiValue.value) {
    return giLevelWord.value ? `GI ${props.gi} · ${giLevelWord.value}` : `GI ${props.gi}`
  }
  return props.giLabel?.trim() || ''
})

const giLevelClass = computed(() => (giLevel.value ? `fl-item__gi--${giLevel.value}` : ''))
</script>

<style lang="scss" scoped>
.fl-item {
  width: 100%;
  min-height: 112rpx;
  padding: 20rpx 22rpx;
  border-radius: 28rpx;
  border: 1rpx solid #e4e8df;
  background: #ffffff;
  box-sizing: border-box;
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 18rpx;
}

.fl-item__gi {
  padding: 8rpx 16rpx;
  border-radius: 14rpx;
  background: #dceedd;
  flex-shrink: 0;
}

.fl-item__gi-text {
  font-size: 22rpx;
  font-weight: 600;
  color: #2d5a27;
  line-height: 1.2;
}

/* 低 GI：绿色 */
.fl-item__gi--low {
  background: #dceedd;
}
.fl-item__gi--low .fl-item__gi-text {
  color: #2d5a27;
}

/* 中 GI：琥珀色 */
.fl-item__gi--mid {
  background: #fdecc8;
}
.fl-item__gi--mid .fl-item__gi-text {
  color: #8a5a00;
}

/* 高 GI：红色 */
.fl-item__gi--high {
  background: #fbdcd6;
}
.fl-item__gi--high .fl-item__gi-text {
  color: #a3271a;
}

.fl-item__main {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 10rpx;
}

.fl-item__name {
  max-width: 100%;
  font-size: 28rpx;
  font-weight: 600;
  color: #222222;
  line-height: 1.35;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.fl-item__kcal {
  font-size: 32rpx;
  font-weight: 700;
  color: #bf360c;
  line-height: 1.25;
}

.fl-item__actions {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 10rpx;
  flex-shrink: 0;
}

.fl-item__edit,
.fl-item__delete {
  width: 56rpx;
  height: 56rpx;
  border-radius: 28rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.fl-item__edit {
  background: #eef6e6;
}

.fl-item__edit-text {
  font-size: 26rpx;
  color: #4b7a2d;
  line-height: 1;
}

.fl-item__delete {
  background: #fff8e1;
}

.fl-item__delete-text {
  font-size: 34rpx;
  font-weight: 700;
  color: #bf360c;
  line-height: 1;
}
</style>
