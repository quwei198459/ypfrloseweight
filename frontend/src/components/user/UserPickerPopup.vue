<template>
  <view v-if="modelValue" class="picker-overlay" @click="onMask">
    <view class="picker-sheet" @click.stop>
      <view class="picker-head">
        <text class="picker-title">{{ title }}</text>
        <view class="picker-close" @click="close">
          <text class="picker-close__icon">×</text>
        </view>
      </view>

      <text v-if="subtitle" class="picker-desc">{{ subtitle }}</text>

      <text class="picker-swipe-hint">上下滑动选择，点「确定」保存</text>

      <view class="picker-body">
        <picker-view
          v-if="options.length > 0"
          class="picker-view-main"
          :value="pickerValue"
          :immediate-change="true"
          indicator-style="height: 88rpx;"
          @change="onPickerViewChange"
        >
          <picker-view-column>
            <view v-for="(opt, i) in options" :key="i" class="pv-row">{{ opt }}</view>
          </picker-view-column>
        </picker-view>
      </view>

      <view class="picker-spacer" />

      <view class="picker-foot">
        <view class="picker-ok" @click="confirm">
          <text class="picker-ok__txt">确定</text>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

const props = withDefaults(
  defineProps<{
    modelValue: boolean
    title: string
    subtitle?: string
    options: string[]
    index: number
  }>(),
  {
    subtitle: '',
    options: () => [],
    index: 0,
  }
)

const emit = defineEmits<{
  (e: 'update:modelValue', v: boolean): void
  (e: 'update:index', v: number): void
  (e: 'confirm-wheel', value: string): void
}>()

const localIndex = ref(props.index)
/** picker-view 绑定值为各列下标数组 */
const pickerValue = ref([0])

function clampIndex(i: number): number {
  const n = props.options.length
  if (n <= 0) return 0
  if (i < 0) return 0
  if (i >= n) return n - 1
  return i
}

function syncPickerFromProps() {
  const i = clampIndex(props.index)
  localIndex.value = i
  pickerValue.value = [i]
}

watch(
  () => props.modelValue,
  (open) => {
    if (open) {
      syncPickerFromProps()
    }
  }
)

watch(
  () => props.index,
  () => {
    if (props.modelValue) {
      syncPickerFromProps()
    }
  }
)

watch(
  () => props.options.length,
  () => {
    if (props.modelValue) {
      syncPickerFromProps()
    }
  }
)

function onPickerViewChange(e: { detail?: { value?: number[] } }) {
  const arr = e.detail?.value
  const i = arr != null && arr.length > 0 ? clampIndex(arr[0]!) : 0
  localIndex.value = i
  pickerValue.value = [i]
  emit('update:index', i)
}

function close() {
  emit('update:modelValue', false)
}

function onMask() {
  close()
}

function confirm() {
  const i = clampIndex(localIndex.value)
  emit('update:index', i)
  const v = props.options[i]
  if (v != null) emit('confirm-wheel', v)
  close()
}
</script>

<style lang="scss" scoped>
@use './user-variables.scss' as *;

.picker-overlay {
  position: fixed;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  z-index: 1000;
  background: $user-mask;
  display: flex;
  flex-direction: column;
  justify-content: flex-end;
}

.picker-sheet {
  width: 100%;
  background: #fff;
  border-radius: 48rpx 48rpx 0 0;
  padding: 36rpx 32rpx 0;
  padding-bottom: calc(44rpx + env(safe-area-inset-bottom));
  box-sizing: border-box;
  min-height: 880rpx;
  display: flex;
  flex-direction: column;
}

.picker-head {
  position: relative;
  height: 96rpx;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.picker-title {
  font-size: 34rpx;
  font-weight: 600;
  color: $user-text-primary;
}

.picker-close {
  position: absolute;
  right: 0;
  top: 8rpx;
  width: 80rpx;
  height: 80rpx;
  display: flex;
  align-items: center;
  justify-content: center;
}

.picker-close__icon {
  font-size: 44rpx;
  color: $user-close;
  line-height: 1;
}

.picker-desc {
  display: block;
  width: 100%;
  text-align: center;
  font-size: 24rpx;
  color: $user-text-secondary;
  line-height: 1.35;
  margin-bottom: 12rpx;
  padding: 0 8rpx;
  box-sizing: border-box;
}

.picker-swipe-hint {
  display: block;
  text-align: center;
  font-size: 22rpx;
  color: $user-text-hint;
  margin-bottom: 16rpx;
}

.picker-body {
  width: 100%;
  flex-shrink: 0;
  padding: 0 16rpx;
  box-sizing: border-box;
}

.picker-view-main {
  width: 100%;
  height: 440rpx;
}

.pv-row {
  height: 88rpx;
  line-height: 88rpx;
  text-align: center;
  font-size: 32rpx;
  color: $user-text-primary;
}

.picker-spacer {
  flex: 1;
  min-height: 24rpx;
}

.picker-foot {
  flex-shrink: 0;
  width: 100%;
  display: flex;
  justify-content: center;
  padding-top: 8rpx;
}

.picker-ok {
  width: 600rpx;
  height: 96rpx;
  border-radius: 48rpx;
  background: $user-save-bg;
  display: flex;
  align-items: center;
  justify-content: center;
}

.picker-ok__txt {
  font-size: 32rpx;
  font-weight: 600;
  color: $user-text-primary;
}
</style>
