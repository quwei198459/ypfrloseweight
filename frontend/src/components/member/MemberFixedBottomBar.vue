<template>
  <view class="member-fixed-bottom-bar">
    <view class="member-fixed-bottom-bar__btn" @click="onPrimary">
      <text class="member-fixed-bottom-bar__btn-text">{{ primaryText }}</text>
    </view>
    <view class="member-fixed-bottom-bar__agreement" @click="onToggleAgreement">
      <view
        class="member-fixed-bottom-bar__checkbox"
        :class="{ 'member-fixed-bottom-bar__checkbox--on': agreementChecked }"
      >
        <text v-if="agreementChecked" class="member-fixed-bottom-bar__check">✓</text>
      </view>
      <text class="member-fixed-bottom-bar__agreement-text">
        我已阅读并同意
        <text class="member-fixed-bottom-bar__link">《会员服务协议》</text>
      </text>
    </view>
  </view>
</template>

<script setup>
defineProps({
  primaryText: {
    type: String,
    default: '立即开通',
  },
  agreementChecked: {
    type: Boolean,
    default: false,
  },
})

const emit = defineEmits(['primary', 'toggle-agreement'])

function onPrimary() {
  emit('primary')
}

function onToggleAgreement() {
  emit('toggle-agreement')
}
</script>

<style lang="scss" scoped>
.member-fixed-bottom-bar {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 500;
  display: flex;
  flex-direction: column;
  align-items: stretch;
  gap: 24rpx;
  padding: 24rpx 32rpx;
  padding-bottom: calc(24rpx + env(safe-area-inset-bottom));
  background: linear-gradient(180deg, rgba(245, 247, 250, 0) 0%, #f5f7fa 16%, #f5f7fa 100%);
  box-sizing: border-box;
}

.member-fixed-bottom-bar__btn {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  min-height: 96rpx;
  padding: 0 40rpx;
  background: linear-gradient(90deg, #ffb74d 0%, #ff9800 100%);
  border-radius: 48rpx;
  box-shadow: 0 8rpx 24rpx rgba(255, 152, 0, 0.35);
}

.member-fixed-bottom-bar__btn-text {
  font-size: 32rpx;
  font-weight: 600;
  color: #ffffff;
}

.member-fixed-bottom-bar__agreement {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
  gap: 16rpx;
  padding: 0 8rpx;
}

.member-fixed-bottom-bar__checkbox {
  flex-shrink: 0;
  width: 36rpx;
  height: 36rpx;
  margin-top: 4rpx;
  border-radius: 8rpx;
  border: 2rpx solid #bdbdbd;
  background: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
}

.member-fixed-bottom-bar__checkbox--on {
  background: #ff9800;
  border-color: #ff9800;
}

.member-fixed-bottom-bar__check {
  font-size: 22rpx;
  font-weight: 700;
  color: #ffffff;
  line-height: 1;
}

.member-fixed-bottom-bar__agreement-text {
  flex: 1;
  font-size: 24rpx;
  color: #666666;
  line-height: 1.5;
}

.member-fixed-bottom-bar__link {
  color: #ff9800;
  font-weight: 500;
}
</style>
