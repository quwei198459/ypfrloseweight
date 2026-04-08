<template>
  <view class="info-card">
    <UserInfoRow label="性别" :value="gender" @click="$emit('gender')" />
    <view class="info-divider" />
    <UserInfoRow label="年龄" :value="age" @click="$emit('age')" />
    <view class="info-divider" />
    <UserInfoRow label="身高" :value="height" @click="$emit('height')" />
    <view class="info-divider" />
    <UserInfoRow label="最新体重" :value="currentWeight" @click="$emit('weight')" />
    <view class="info-divider" />
    <UserInfoRow label="目标体重" :value="targetWeight" @click="$emit('target-weight')" />
    <view class="info-divider" />
    <UserInfoRow label="目标达成时间" :value="targetDate" @click="$emit('target-date')" />
  </view>
</template>

<script setup lang="ts">
import UserInfoRow from './UserInfoRow.vue'

defineProps<{
  gender: string
  age: string
  height: string
  currentWeight: string
  targetWeight: string
  targetDate: string
}>()

defineEmits<{
  (e: 'gender'): void
  (e: 'age'): void
  (e: 'height'): void
  (e: 'weight'): void
  (e: 'target-weight'): void
  (e: 'target-date'): void
}>()
</script>

<style lang="scss" scoped>
@use './user-variables.scss' as *;

.info-card {
  background: $user-card-bg;
  border-radius: $user-card-radius;
  box-shadow: $user-card-shadow;
  padding: 16rpx 32rpx;
}

.info-divider {
  height: 2rpx;
  background: $user-row-divider;
  width: 100%;
}
</style>
