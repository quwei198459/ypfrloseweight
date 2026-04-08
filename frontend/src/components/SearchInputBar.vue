<template>
  <view class="search-input-bar" @click="onSearchClick">
    <view class="search-icon" />
    <text class="placeholder">{{ placeholder }}</text>
  </view>
</template>

<script setup lang="ts">
const props = defineProps<{
  placeholder: string
}>()

const emit = defineEmits<{
  (e: 'click-search'): void
}>()

const onSearchClick = () => {
  emit('click-search')
}
</script>

<style scoped lang="scss">
.search-input-bar {
  width: 100%;
  height: 44px;
  border-radius: 22px;
  background: #ffffff;
  padding: 0 14px;
  display: flex;
  align-items: center;
  box-sizing: border-box;
  flex: 1;
  min-width: 0;
}

.search-icon {
  width: 16px;
  height: 16px;
  border-radius: 8px;
  background: #a0a0a0;
}

.placeholder {
  margin-left: 8px;
  font-size: 12px;
  color: #b3b3b3;
}
</style>

