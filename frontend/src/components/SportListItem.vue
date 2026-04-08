<template>
  <view class="sport-item">
    <view class="thumb" />
    <view class="info">
      <text class="name">{{ name }}</text>
      <text class="calories">{{ caloriesText }}</text>
    </view>
    <view class="action" @click="emit('select')">
      <view class="add-btn">
        <text class="add-symbol">+</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
const props = defineProps<{
  name: string
  caloriesText: string
}>()

const emit = defineEmits<{
  (e: 'select'): void
}>()
</script>

<style scoped lang="scss">
.sport-item {
  width: 100%;
  height: 72px;
  border-radius: 16px;
  border: 1px solid #e6e6e6;
  background: #ffffff;
  padding: 8px 12px;
  box-sizing: border-box;
  display: flex;
  align-items: center;
  gap: 12px;
}

.thumb {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  background: #e6f0ff;
}

.info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 4px;
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

.action {
  width: 28px;
  height: 28px;
}

.add-btn {
  width: 28px;
  height: 28px;
  border-radius: 14px;
  background: #f4f8e8;
  display: flex;
  align-items: center;
  justify-content: center;
}

.add-symbol {
  font-size: 18px;
  color: #9ebc86;
}
</style>

