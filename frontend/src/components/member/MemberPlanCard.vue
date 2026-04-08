<template>
  <view
    class="mpc"
    :class="[
      `mpc--${variant}`,
      { 'mpc--selected': selected },
    ]"
    @click="onClick"
  >
    <!-- 挂角标签：仅 featured 且存在 tag -->
    <view v-if="variant === 'featured' && plan.tag" class="mpc__corner-wrap" aria-hidden="true">
      <view class="mpc__corner-badge">
        <text class="mpc__corner-text">{{ plan.tag }}</text>
      </view>
    </view>

    <view class="mpc__inner">
      <template v-if="variant === 'featured'">
        <view class="mpc__title-group">
          <text class="mpc__title">{{ plan.title }}</text>
          <text v-if="plan.desc" class="mpc__desc">{{ plan.desc }}</text>
        </view>
        <view class="mpc__price-group">
          <text class="mpc__price">¥{{ plan.price }}</text>
          <text class="mpc__origin">原价：¥{{ plan.originPrice }}</text>
        </view>
      </template>

      <template v-else>
        <view class="mpc__row">
          <view class="mpc__title-group mpc__title-group--compact">
            <text class="mpc__title">{{ plan.title }}</text>
            <text v-if="plan.desc" class="mpc__desc mpc__desc--compact">{{ plan.desc }}</text>
          </view>
          <view class="mpc__price-group mpc__price-group--right">
            <text class="mpc__price mpc__price--compact">¥{{ plan.price }}</text>
            <text class="mpc__origin">原价：¥{{ plan.originPrice }}</text>
          </view>
        </view>
      </template>
    </view>
  </view>
</template>

<script setup>
const props = defineProps({
  plan: {
    type: Object,
    required: true,
  },
  variant: {
    type: String,
    default: 'compact',
    validator: (v) => ['featured', 'compact'].includes(v),
  },
  selected: {
    type: Boolean,
    default: false,
  },
})

const emit = defineEmits(['select'])

function onClick() {
  emit('select', props.plan.id)
}
</script>

<style lang="scss" scoped>
.mpc {
  position: relative;
  box-sizing: border-box;
  background: #ffffff;
  border-radius: 48rpx;
  overflow: visible;
}

.mpc--featured {
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
  align-items: stretch;
  padding: 20rpx 24rpx 24rpx;
  border-width: 6rpx;
  border-style: solid;
  border-color: #e0e0e0;
}

.mpc--featured.mpc--selected {
  border-color: #ff9800;
}

.mpc--compact {
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
  padding: 24rpx;
  border: 2rpx solid #e0e0e0;
}

.mpc--compact.mpc--selected {
  border-color: #ff9800;
}

.mpc__corner-wrap {
  position: absolute;
  top: -6rpx;
  left: -4rpx;
  z-index: 2;
  pointer-events: none;
}

.mpc__corner-badge {
  padding: 6rpx 16rpx;
  background: #e53935;
  border-radius: 8rpx;
  transform: rotate(-4deg);
  box-shadow: 0 4rpx 8rpx rgba(229, 57, 53, 0.25);
}

.mpc__corner-text {
  font-size: 20rpx;
  font-weight: 600;
  color: #ffffff;
}

.mpc__inner {
  flex: 1;
  min-height: 0;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  gap: 16rpx;
}

.mpc--compact .mpc__inner {
  gap: 0;
}

.mpc__row {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16rpx;
  width: 100%;
}

.mpc__title-group {
  display: flex;
  flex-direction: column;
  gap: 8rpx;
  min-width: 0;
}

.mpc__title-group--compact {
  flex: 1;
  min-width: 0;
}

.mpc__title {
  font-size: 32rpx;
  font-weight: 700;
  color: #1a1a1a;
  line-height: 1.3;
}

.mpc--compact .mpc__title {
  font-size: 30rpx;
}

.mpc__desc {
  font-size: 20rpx;
  color: #888888;
  line-height: 1.4;
}

.mpc__desc--compact {
  margin-top: 4rpx;
}

.mpc__price-group {
  display: flex;
  flex-direction: column;
  gap: 4rpx;
}

.mpc__price-group--right {
  flex-shrink: 0;
  align-items: flex-end;
  text-align: right;
}

.mpc__price {
  font-size: 40rpx;
  font-weight: 700;
  color: #e53935;
  line-height: 1.2;
}

.mpc__price--compact {
  font-size: 34rpx;
}

.mpc__origin {
  font-size: 20rpx;
  color: #aaaaaa;
  line-height: 1.3;
}
</style>
