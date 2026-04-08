<template>
  <view v-if="show" class="wem">
    <view class="wem__mask" @tap="emitClose" />
    <view class="wem__panel" @tap.stop>
      <text class="wem__panda" aria-hidden="true">🐼</text>
      <text class="wem__title">{{ title }}</text>

      <view class="wem__tabs">
        <view class="wem__tab" @tap="unit = 'jin'">
          <view class="wem__tab-label-row">
            <text class="wem__tab-text" :class="{ 'wem__tab-text--on': unit === 'jin' }">斤</text>
          </view>
          <view class="wem__tab-underline-slot">
            <view v-if="unit === 'jin'" class="wem__tab-line" />
            <view v-else class="wem__tab-line wem__tab-line--placeholder" />
          </view>
        </view>
        <view class="wem__tab" @tap="unit = 'kg'">
          <view class="wem__tab-label-row">
            <text class="wem__tab-text" :class="{ 'wem__tab-text--on': unit === 'kg' }">公斤</text>
          </view>
          <view class="wem__tab-underline-slot">
            <view v-if="unit === 'kg'" class="wem__tab-line" />
            <view v-else class="wem__tab-line wem__tab-line--placeholder" />
          </view>
        </view>
      </view>

      <view class="wem__input-wrap">
        <input
          class="wem__input"
          type="digit"
          :value="inputVal"
          placeholder=""
          @input="onInput"
        />
      </view>

      <view class="wem__actions">
        <view class="wem__btn wem__btn--cancel" @tap="emitClose">
          <text class="wem__btn-txt wem__btn-txt--cancel">取消</text>
        </view>
        <view class="wem__btn wem__btn--ok" @tap="onConfirm">
          <text class="wem__btn-txt wem__btn-txt--ok">确定</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

const props = defineProps<{
  show: boolean
  title: string
  /** 打开弹层时填入输入框；空字符串表示空输入 */
  defaultValue: string
}>()

const emit = defineEmits<{
  'update:show': [value: boolean]
  confirm: [valueJin: number]
}>()

const unit = ref<'jin' | 'kg'>('jin')
const inputVal = ref('')

watch(
  () => props.show,
  (v) => {
    if (v) {
      unit.value = 'jin'
      inputVal.value = props.defaultValue
    }
  },
)

function onInput(e: { detail?: { value?: string } }) {
  inputVal.value = String(e.detail?.value ?? '')
}

function emitClose() {
  emit('update:show', false)
}

function onConfirm() {
  const raw = String(inputVal.value || '').trim()
  const n = parseFloat(raw.replace(/,/g, ''))
  if (!Number.isFinite(n) || n <= 0) {
    uni.showToast({ title: '请输入有效体重', icon: 'none' })
    return
  }
  const jin = unit.value === 'kg' ? n * 2 : n
  emit('confirm', jin)
  emit('update:show', false)
}
</script>

<style lang="scss" scoped>
@use './user-variables.scss' as *;

.wem {
  position: fixed;
  left: 0;
  top: 0;
  right: 0;
  bottom: 0;
  z-index: 1000;
  display: flex;
  align-items: center;
  justify-content: center;
}

.wem__mask {
  position: absolute;
  left: 0;
  top: 0;
  right: 0;
  bottom: 0;
  background: $user-mask;
}

.wem__panel {
  position: relative;
  width: 602rpx;
  max-width: 90%;
  margin-top: -40rpx;
  padding: 48rpx 40rpx 36rpx;
  box-sizing: border-box;
  background: #ffffff;
  border-radius: 52rpx;
  border: 3rpx solid #1a1a1a;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 24rpx;
}

.wem__panda {
  position: absolute;
  left: 32rpx;
  top: -36rpx;
  font-size: 56rpx;
  line-height: 1;
}

.wem__title {
  font-size: 36rpx;
  font-weight: 600;
  color: $user-text-primary;
}

.wem__tabs {
  display: flex;
  flex-direction: row;
  align-items: flex-start;
  justify-content: center;
  gap: 64rpx;
}

.wem__tab {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8rpx;
}

.wem__tab-label-row {
  min-height: 44rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.wem__tab-text {
  font-size: 30rpx;
  color: $user-text-secondary;
  line-height: 1.2;
}

.wem__tab-text--on {
  font-weight: 600;
  color: $user-text-primary;
}

.wem__tab-underline-slot {
  height: 6rpx;
  display: flex;
  align-items: flex-start;
  justify-content: center;
}

.wem__tab-line {
  width: 44rpx;
  height: 6rpx;
  border-radius: 3rpx;
  background: #7cb342;
}

.wem__tab-line--placeholder {
  background: transparent;
}

.wem__input-wrap {
  width: 100%;
  box-sizing: border-box;
}

.wem__input {
  width: 100%;
  height: 112rpx;
  line-height: 112rpx;
  padding: 0 32rpx;
  box-sizing: border-box;
  font-size: 44rpx;
  font-weight: 600;
  color: $user-text-primary;
  border: 3rpx solid #1a1a1a;
  border-radius: 28rpx;
  background: #ffffff;
}

.wem__actions {
  width: 100%;
  display: flex;
  flex-direction: row;
  gap: 28rpx;
  margin-top: 8rpx;
}

.wem__btn {
  flex: 1 1 0;
  min-width: 0;
  height: 92rpx;
  border-radius: 46rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.wem__btn--cancel {
  background: #ffffff;
  border: 3rpx solid #7cb342;
}

.wem__btn--ok {
  background: $user-save-bg;
  border: 3rpx solid transparent;
}

.wem__btn-txt {
  font-size: 30rpx;
  font-weight: 600;
}

.wem__btn-txt--cancel {
  color: #4a7c2c;
}

.wem__btn-txt--ok {
  color: $user-text-primary;
}
</style>
