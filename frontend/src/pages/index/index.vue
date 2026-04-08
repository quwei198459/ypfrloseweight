<template>
  <view class="home-container">
    <text class="title">首页</text>
  </view>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'Index',
})
</script>

<style scoped>
.home-container {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100vh;
}

.title {
  font-size: 36rpx;
  color: #333;
}
</style>
