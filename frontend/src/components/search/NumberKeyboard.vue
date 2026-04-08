<template>
  <view class="number-keyboard">
    <view class="number-grid">
      <view
        v-for="d in digitKeys"
        :key="d"
        class="key-cell"
        @click="emit('input', d)"
      >
        <text class="key-text">{{ d }}</text>
      </view>
      <view class="key-cell key-dot" @click="emit('input', '.')">
        <text class="key-text">.</text>
      </view>
      <view class="key-cell key-zero" @click="emit('input', '0')">
        <text class="key-text">0</text>
      </view>
    </view>
    <view class="action-column">
      <view class="delete-button" @click="emit('delete')">
        <text class="delete-icon">⌫</text>
      </view>
      <view class="confirm-button" @click="emit('confirm')">
        <text class="confirm-text">确定</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
const digitKeys = ['1', '2', '3', '4', '5', '6', '7', '8', '9'] as const

const emit = defineEmits<{
  (e: 'input', key: string): void
  (e: 'delete'): void
  (e: 'confirm'): void
}>()
</script>

<style lang="scss" scoped>
/* 设计稿：键高 40、键间距 6、行间距 4；操作列与数字区总高 172（344rpx） */
$row: 80rpx;
$gap: 12rpx;
$row-gap: 8rpx;
$keyboard-h: 344rpx;

.number-keyboard {
  display: flex;
  flex-direction: row;
  align-items: stretch;
  gap: 12rpx;
  width: 100%;
  box-sizing: border-box;
}

.number-grid {
  flex: 1;
  min-width: 0;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-auto-rows: $row;
  column-gap: $gap;
  row-gap: $row-gap;
  height: $keyboard-h;
  align-content: start;
}

.key-cell {
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fafafa;
  border: 1rpx solid #e0e0e0;
  border-radius: 16rpx;
  box-sizing: border-box;
}

.key-text {
  font-size: 32rpx;
  color: #212121;
}

.key-zero {
  grid-column: span 2;
}

.action-column {
  width: 104rpx;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  gap: 12rpx;
  height: $keyboard-h;
  box-sizing: border-box;
}

.delete-button {
  height: 112rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fafafa;
  border: 1rpx solid #e0e0e0;
  border-radius: 16rpx;
  box-sizing: border-box;
}

.delete-icon {
  font-size: 36rpx;
  color: #616161;
}

.confirm-button {
  flex: 1;
  min-height: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #c5e1a5;
  border-radius: 16rpx;
  box-sizing: border-box;
}

.confirm-text {
  font-size: 28rpx;
  font-weight: 600;
  color: #33691e;
}
</style>
