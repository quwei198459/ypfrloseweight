<template>
  <view class="info-card">
    <UserInfoRow label="性别" :value="gender" @click="$emit('gender')" />
    <view class="info-divider" />
    <picker mode="date" :value="birthday" @change="(e) => $emit('birthday-change', e.detail.value)">
      <UserInfoRow label="出生日期" :value="birthday || '请选择'" />
    </picker>
    <view class="info-divider" />
    <UserInfoRow label="年龄" :value="age" @click="$emit('age')" />
    <view class="info-divider" />
    <picker
      mode="multiSelector"
      :range="regionRange"
      :value="regionIndex"
      @columnchange="(e) => $emit('residence-column-change', e.detail.column, e.detail.value)"
      @change="(e) => $emit('residence-change', e.detail.value as number[])"
    >
      <UserInfoRow label="居住地" :value="residence || '请选择'" />
    </picker>
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
  birthday: string
  age: string
  residence: string
  regionRange: string[][]
  regionIndex: number[]
  height: string
  currentWeight: string
  targetWeight: string
  targetDate: string
}>()

defineEmits<{
  (e: 'gender'): void
  (e: 'birthday-change', value: string): void
  (e: 'age'): void
  (e: 'residence-column-change', column: number, value: number): void
  (e: 'residence-change', value: number[]): void
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
