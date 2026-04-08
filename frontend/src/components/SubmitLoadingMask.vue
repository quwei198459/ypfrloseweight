<template>
  <view v-if="visible" class="overlay">
    <view class="card">
      <view class="spinner" />
      <text class="text">记录中</text>
    </view>
  </view>
</template>

<script setup lang="ts">
defineProps<{
  visible: boolean
}>()
</script>

<style scoped lang="scss">
.overlay {
  position: fixed;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 60;
}

.card {
  width: 120px;
  height: 120px;
  border-radius: 16px;
  background: rgba(75, 75, 75, 0.92);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 12px;
}

.spinner {
  width: 40px;
  height: 40px;
  border-radius: 20px;
  border: 4px solid rgba(138, 138, 138, 1);
  border-top-color: rgba(255, 255, 255, 0);
  animation: spin 0.9s linear infinite;
}

.text {
  font-size: 14px;
  font-weight: 600;
  color: #ffffff;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
</style>

