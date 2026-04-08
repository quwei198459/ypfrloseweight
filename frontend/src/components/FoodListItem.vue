<template>
  <view class="food-item">
    <view class="thumb">
      <image v-if="image" class="thumb-image" :src="image" mode="aspectFill" />
    </view>
    <view class="info">
      <view class="name-row">
        <view v-if="giLevel" class="gi-tag" :class="`gi-${giLevel}`">{{ giText }}</view>
        <text class="name">{{ name }}</text>
      </view>
      <text class="calories">{{ caloriesText }}</text>
    </view>
    <view class="action" @click.stop="toggle">
      <view
        v-if="!checked"
        class="add-btn"
      >
        <text class="add-symbol">+</text>
      </view>
      <view
        v-else
        class="checked-btn"
      >
        <text class="check-symbol">✓</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  name: string
  caloriesText: string
  image?: string
  giLevel?: string
  checked?: boolean
}>()

const emit = defineEmits<{
  (e: 'toggle'): void
}>()

const toggle = () => emit('toggle')

const giText = computed(() => {
  if (props.giLevel === 'high') return '高GI'
  if (props.giLevel === 'medium') return '中GI'
  if (props.giLevel === 'low') return '低GI'
  return ''
})
</script>

<style scoped lang="scss">
.food-item {
  width: 100%;
  height: 72px;
  border-radius: 16px;
  border: 1px solid #e6e6e6;
  background: #ffffff;
  padding: 8px 12px;
  box-sizing: border-box;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.thumb {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  background: #f5f1e6;
  overflow: hidden;
}

.thumb-image {
  width: 100%;
  height: 100%;
}

.info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.name-row {
  display: flex;
  align-items: center;
  gap: 6px;
}

.name {
  font-size: 14px;
  font-weight: 600;
  color: #222222;
}

.calories {
  font-size: 12px;
  color: #8a8a8a;
}

.gi-tag {
  font-size: 10px;
  line-height: 16px;
  padding: 0 6px;
  border-radius: 6px;
}

.gi-low {
  color: #5f8d45;
  background: #e8f5e9;
}

.gi-medium {
  color: #d38645;
  background: #fff3e0;
}

.gi-high {
  color: #d16f6f;
  background: #ffebee;
}

.action {
  width: 28px;
  height: 28px;
}

.add-btn,
.checked-btn {
  width: 28px;
  height: 28px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.add-btn {
  background: #f4f8e8;
}

.checked-btn {
  background: #9ebc86;
}

.add-symbol {
  font-size: 18px;
  color: #9ebc86;
}

.check-symbol {
  font-size: 14px;
  color: #ffffff;
}
</style>

