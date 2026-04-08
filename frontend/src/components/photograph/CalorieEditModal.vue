<template>
  <view class="cem-root" @click="emit('cancel')">
    <view class="cem-panel" @click.stop>
      <text class="cem-title">修改热量</text>
      <view class="cem-row">
        <view class="cem-input-wrap">
          <input
            class="cem-input"
            type="digit"
            :value="modelValue"
            placeholder="0"
            @input="onInput"
          />
        </view>
        <text class="cem-unit">千卡</text>
      </view>
      <view class="cem-actions">
        <view class="cem-btn cem-btn--ghost" @click="emit('cancel')">
          <text class="cem-btn-text cem-btn-text--ghost">取消</text>
        </view>
        <view class="cem-btn cem-btn--primary" @click="emit('confirm')">
          <text class="cem-btn-text cem-btn-text--primary">确认</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
const props = defineProps<{
  modelValue: string
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', v: string): void
  (e: 'confirm'): void
  (e: 'cancel'): void
}>()

function onInput(e: { detail: { value: string } }) {
  emit('update:modelValue', e.detail.value)
}
</script>

<style lang="scss" scoped>
.cem-root {
  position: fixed;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  z-index: 200;
  background: rgba(0, 0, 0, 0.35);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 48rpx;
  box-sizing: border-box;
}

.cem-panel {
  width: 100%;
  max-width: 576rpx;
  background: #ffffff;
  border-radius: 32rpx;
  border: 1rpx solid #dddddd;
  padding: 36rpx;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 28rpx;
}

.cem-title {
  font-size: 32rpx;
  font-weight: 700;
  color: #222222;
  line-height: 1.3;
}

.cem-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 20rpx;
}

.cem-input-wrap {
  width: 200rpx;
  height: 84rpx;
  border-radius: 20rpx;
  background: #f1f8e9;
  border: 4rpx solid #9ebc86;
  box-sizing: border-box;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 16rpx;
}

.cem-input {
  width: 100%;
  text-align: center;
  font-size: 44rpx;
  font-weight: 700;
  color: #1a1a1a;
}

.cem-unit {
  font-size: 30rpx;
  color: #444444;
}

.cem-actions {
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  gap: 24rpx;
  margin-top: 8rpx;
}

.cem-btn {
  flex: 1;
  height: 88rpx;
  border-radius: 44rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
}

.cem-btn--ghost {
  background: #ffffff;
  border: 3rpx solid #8fa67a;
}

.cem-btn--primary {
  background: #d5e7b1;
  border: 2rpx solid #9ebc86;
}

.cem-btn-text {
  font-size: 28rpx;
  font-weight: 600;
}

.cem-btn-text--ghost {
  color: #4b5b2d;
}

.cem-btn-text--primary {
  color: #2d3d22;
}
</style>
