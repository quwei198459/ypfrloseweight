<template>
  <view class="fc">
    <view class="fc__row-a">
      <view class="fc__gi">
        <text class="fc__gi-text">{{ giLabel }}</text>
      </view>
      <view class="fc__name-row">
        <text class="fc__name">{{ foodName }}</text>
        <text class="fc__edit" @click.stop="emit('edit')">✎</text>
        <view class="fc__del" @click.stop="emit('delete')">
          <text class="fc__del-x">×</text>
        </view>
      </view>
    </view>
    <view class="fc__row-b">
      <text class="fc__kcal">{{ calories }} 千卡</text>
    </view>
  </view>
</template>

<script setup lang="ts">
defineProps<{
  foodName: string
  giLabel: string
  calories: number
}>()

const emit = defineEmits<{
  (e: 'edit'): void
  (e: 'delete'): void
}>()
</script>

<style lang="scss" scoped>
.fc {
  width: 392rpx;
  max-width: 88%;
  background: #ffffff;
  border-radius: 24rpx;
  border: 1rpx solid #e8e8e8;
  padding: 12rpx 16rpx;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
  gap: 8rpx;
}

.fc__row-a {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 16rpx;
  width: 100%;
}

.fc__gi {
  padding: 8rpx 16rpx;
  border-radius: 12rpx;
  background: #dceedd;
  flex-shrink: 0;
}

.fc__gi-text {
  font-size: 22rpx;
  color: #2d5a27;
  font-weight: 600;
}

.fc__name-row {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 12rpx;
}

.fc__name {
  flex: 1;
  min-width: 0;
  font-size: 26rpx;
  font-weight: 600;
  color: #222222;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.fc__edit {
  font-size: 26rpx;
  color: #4b7a2d;
  padding: 4rpx;
  flex-shrink: 0;
}

.fc__del {
  width: 56rpx;
  height: 56rpx;
  border-radius: 28rpx;
  background: #fff8e1;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.fc__del-x {
  font-size: 32rpx;
  font-weight: 700;
  color: #bf360c;
  line-height: 1;
}

.fc__row-b {
  padding-left: 4rpx;
}

.fc__kcal {
  font-size: 32rpx;
  font-weight: 700;
  color: #bf360c;
  line-height: 1.3;
}
</style>
