<template>
  <view class="add-circle-button" @click="$emit('click')">
    <text class="symbol">+</text>
  </view>
</template>

<script setup lang="ts">
defineEmits<{
  (e: 'click'): void
}>()
</script>

<style scoped lang="scss">
.add-circle-button {
  width: 40px;
  height: 40px;
  border-radius: 20px;
  background: #d5e7b1;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  position: relative;
  z-index: 3;
}

.symbol {
  font-size: 20px;
  color: #4b5b2d;
}
</style>

