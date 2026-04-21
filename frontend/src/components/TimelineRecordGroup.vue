<template>
  <view class="timeline-group">
    <view class="header">
      <view class="icon" :class="iconClass" />
      <text class="title">{{ title }}</text>
      <text class="time">{{ time }}</text>
    </view>
    <view class="card" v-if="type === 'sport'">
      <view class="thumb sport" />
      <view class="text-col">
        <text class="main-text">{{ sportName }}</text>
        <text class="sub-text">{{ sportDetail }}</text>
      </view>
    </view>
    <view class="card" v-else>
      <view class="header-row">
        <text class="main-text">{{ mealTitle }}</text>
        <text class="calories">{{ mealCalories }}</text>
      </view>
      <view
        v-for="(f, i) in mealFoodsSafe"
        :key="`${f.name}_${f.amount}_${f.calories}_${i}`"
        class="food-row"
        :class="{ 'food-row--sep': i > 0 }"
      >
        <view class="thumb meal" />
        <view class="text-col food-text-col">
          <text class="main-text">{{ f.name }}</text>
          <text class="sub-text">{{ f.amount }}</text>
        </view>
        <text class="food-calories">{{ f.calories }}</text>
      </view>
      <view v-if="mealFoodsSafe.length === 0" class="food-row">
        <view class="thumb meal" />
        <view class="text-col">
          <text class="main-text">{{ foodName }}</text>
          <text class="sub-text">{{ foodAmount }}</text>
          <text class="sub-text">{{ foodCalories }}</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  type: 'sport' | 'meal'
  title: string
  time: string
  sportName?: string
  sportDetail?: string
  mealTitle?: string
  mealCalories?: string
  mealFoods?: Array<{
    name?: string
    amount?: string
    calories?: string
  }>
  foodName?: string
  foodAmount?: string
  foodCalories?: string
}>()

const iconClass = computed(() =>
  props.type === 'sport' ? 'icon-sport' : 'icon-meal'
)

const mealFoodsSafe = computed(() => {
  if (!Array.isArray(props.mealFoods)) return []
  return props.mealFoods.map((x) => ({
    name: x?.name || '',
    amount: x?.amount || '',
    calories: x?.calories || '',
  }))
})
</script>

<style scoped lang="scss">
.timeline-group {
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.header {
  display: flex;
  align-items: center;
  gap: 6px;
}

.icon {
  width: 18px;
  height: 18px;
  border-radius: 9px;
}

.icon-sport {
  background: #e6f0ff;
}

.icon-meal {
  background: #ffefd5;
}

.title {
  font-size: 12px;
  font-weight: 600;
  color: #222222;
}

.time {
  font-size: 11px;
  color: #8a8a8a;
}

.card {
  margin-top: 2px;
  width: 100%;
  border-radius: 16px;
  background: #ffffff;
  padding: 8px 10px;
  box-sizing: border-box;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.07);
}

.thumb {
  width: 32px;
  height: 32px;
  border-radius: 16px;
}

.thumb.sport {
  background: #e6f0ff;
}

.thumb.meal {
  border-radius: 8px;
  background: #fff0d9;
}

.text-col {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.main-text {
  font-size: 12px;
  font-weight: 600;
  color: #222222;
}

.sub-text {
  font-size: 11px;
  color: #555555;
}

.calories {
  font-size: 11px;
  color: #4b7a2d;
}

.header-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 6px;
}

.food-row {
  display: flex;
  align-items: center;
  gap: 8px;
}

.food-row--sep {
  border-top: 1px solid #f1f3ec;
  margin-top: 8px;
  padding-top: 8px;
}

.food-text-col {
  flex: 1;
  min-width: 0;
}

.food-calories {
  font-size: 11px;
  color: #4b7a2d;
  flex-shrink: 0;
}
</style>
