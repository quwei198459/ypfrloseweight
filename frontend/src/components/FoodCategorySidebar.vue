<template>
  <view class="category-sidebar">
    <view
      v-for="item in items"
      :key="item.key"
      class="category-item"
      :class="{ active: item.key === modelValue }"
      @click="onSelect(item.key)"
    >
      <text class="category-label">{{ item.label }}</text>
      <view v-if="item.key === modelValue" class="underline" />
    </view>
  </view>
</template>

<script setup lang="ts">
const props = defineProps<{
  modelValue: string
  /** 来自后端 GET /food-categories，key=code，label=展示名 */
  items: { key: string; label: string }[]
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: string): void
}>()

const onSelect = (key: string) => {
  emit('update:modelValue', key)
}
</script>

<style scoped lang="scss">
.category-sidebar {
  width: 80px;
  border-radius: 20px;
  background: #f6f8f0;
  padding: 16px 8px;
  display: flex;
  flex-direction: column;
}

.category-item {
  padding: 4px 8px;
}

.category-label {
  font-size: 13px;
  color: #8a8a8a;
}

.category-item.active .category-label {
  color: #222222;
  font-weight: 600;
}

.underline {
  margin-top: 4px;
  width: 28px;
  height: 3px;
  border-radius: 2px;
  background: #c5dd97;
}
</style>

