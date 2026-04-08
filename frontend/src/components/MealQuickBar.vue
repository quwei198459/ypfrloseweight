<template>
  <view class="bar">
    <view
      v-for="item in items"
      :key="item.key"
      class="item"
      @click="onClick(item.key)"
    >
      <view class="icon-container">
        <image
          class="icon-img"
          :src="categoryIconSrc(item.key)"
          mode="aspectFit"
        />
      </view>
      <text class="label">{{ item.label }}</text>
      <view class="state">
        <view
          v-if="item.state === 'add'"
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
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  checkedKeys: string[]
  /** 与本地存储 ypfw_meal_icon_active 同步，用于高亮当前餐次图标 */
  activeMealKey?: string | null
}>()

const emit = defineEmits<{
  (e: 'click', key: string): void
}>()

function categoryIconSrc(key: string): string {
  const on = props.activeMealKey === key
  return on
    ? `/static/category/category-${key}-active.png`
    : `/static/category/category-${key}.png`
}

const items = computed(() => {
  const base = [
    { key: 'breakfast', label: '早餐' },
    { key: 'lunch', label: '午餐' },
    { key: 'dinner', label: '晚餐' },
    { key: 'snack', label: '加餐' },
    { key: 'sport', label: '运动' },
  ]
  return base.map(i => ({
    ...i,
    state:
      i.key === 'snack' || i.key === 'sport'
        ? 'checked'
        : 'add',
  }))
})

const onClick = (key: string) => {
  emit('click', key)
}
</script>

<style scoped lang="scss">
.bar {
  position: fixed;
  left: 16px;
  right: 16px;
  bottom: 12px;
  height: 92px;
  border-radius: 24px;
  background: #ffffff;
  padding: 10px 16px;
  box-sizing: border-box;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  z-index: 20;
}

.item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.icon-container {
  width: 32px;
  height: 32px;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(247, 251, 247, 0.9);
}

.icon-img {
  width: 20px;
  height: 20px;
  flex-shrink: 0;
}

.label {
  font-size: 11px;
  color: #555555;
}

.state {
  width: 18px;
  height: 18px;
}

.add-btn,
.checked-btn {
  width: 18px;
  height: 18px;
  border-radius: 9px;
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
  font-size: 12px;
  color: #9ebc86;
}

.check-symbol {
  font-size: 11px;
  color: #ffffff;
}
</style>
