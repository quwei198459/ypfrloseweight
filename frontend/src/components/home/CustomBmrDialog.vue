<template>
  <view v-if="visible" class="custom-bmr-dialog-root" @touchmove.stop.prevent>
    <view class="custom-bmr-dialog-mask" @tap="onMaskTap" />
    <view class="custom-bmr-dialog-card-wrap">
      <view class="custom-bmr-panda-decoration" aria-hidden="true">
        <text class="panda-emoji">🐼</text>
      </view>
      <view class="custom-bmr-dialog-card" @tap.stop>
        <text class="custom-bmr-dialog-title">自定义基础代谢</text>

        <view class="custom-bmr-input-row">
          <view class="custom-bmr-input-field">
            <input
              class="custom-bmr-input-native"
              type="digit"
              :value="String(localBmr)"
              @input="onInput"
            />
          </view>
          <text class="custom-bmr-unit-text">千卡</text>
        </view>

        <view class="custom-bmr-hint-row">
          <text class="custom-bmr-hint-text">设置后将不再按个人信息计算预算，</text>
          <text class="restore-budget-link" @tap.stop="onRestoreTap">恢复</text>
        </view>

        <view class="custom-bmr-action-row">
          <view class="custom-bmr-btn custom-bmr-btn--cancel" @tap.stop="onCancel">
            <text class="custom-bmr-btn-text custom-bmr-btn-text--cancel">取消</text>
          </view>
          <view class="custom-bmr-btn custom-bmr-btn--confirm" @tap.stop="onConfirm">
            <text class="custom-bmr-btn-text custom-bmr-btn-text--confirm">确定</text>
          </view>
        </view>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

const props = withDefaults(
  defineProps<{
    visible: boolean
    /** 默认展示的基础代谢（千卡） */
    defaultBmr?: number
  }>(),
  {
    defaultBmr: 2240,
  },
)

const emit = defineEmits<{
  'update:visible': [value: boolean]
  /** 恢复为按个人信息自动计算预算（占位） */
  restore: []
  /** 确定提交（占位，未接接口） */
  confirm: [bmr: number]
}>()

const localBmr = ref(props.defaultBmr)

watch(
  () => props.visible,
  (v) => {
    if (v) {
      localBmr.value = props.defaultBmr
    }
  },
)

watch(
  () => props.defaultBmr,
  (v) => {
    if (props.visible) {
      localBmr.value = v
    }
  },
)

function close() {
  emit('update:visible', false)
}

function onMaskTap() {
  close()
}

function onInput(e: { detail: { value: string } }) {
  const raw = e.detail.value
  const n = parseInt(String(raw).replace(/\D/g, ''), 10)
  localBmr.value = Number.isFinite(n) && n >= 0 ? n : 0
}

function onRestoreTap() {
  // eslint-disable-next-line no-console
  console.log('[CustomBmrDialog] restore: 恢复为系统自动计算预算（占位）')
  emit('restore')
}

function onCancel() {
  close()
}

function onConfirm() {
  const v = localBmr.value
  // eslint-disable-next-line no-console
  console.log('[CustomBmrDialog] confirm（占位）', v)
  emit('confirm', v)
  close()
}
</script>

<style lang="scss" scoped>
.custom-bmr-dialog-root {
  position: fixed;
  left: 0;
  top: 0;
  right: 0;
  bottom: 0;
  z-index: 10000;
  display: flex;
  align-items: center;
  justify-content: center;
}

.custom-bmr-dialog-mask {
  position: absolute;
  left: 0;
  top: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.45);
}

.custom-bmr-dialog-card-wrap {
  position: relative;
  width: 319px;
  z-index: 1;
}

.custom-bmr-panda-decoration {
  position: absolute;
  left: 8px;
  top: -18px;
  width: 48px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2;
  pointer-events: none;
}

.panda-emoji {
  font-size: 36px;
  line-height: 1;
}

.custom-bmr-dialog-card {
  position: relative;
  width: 319px;
  padding: 28px 20px 20px;
  box-sizing: border-box;
  background-color: #ffffff;
  border-radius: 16px;
  border: 1px solid #e8e8e8;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.custom-bmr-dialog-title {
  font-size: 16px;
  font-weight: 700;
  color: #222222;
  text-align: center;
  line-height: 1.4;
}

.custom-bmr-input-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 8px;
}

.custom-bmr-input-field {
  flex: 1;
  min-width: 0;
  height: 44px;
  padding: 0 14px;
  box-sizing: border-box;
  background-color: #f5f5f5;
  border-radius: 12px;
  border: 1px solid #e0e0e0;
  display: flex;
  align-items: center;
}

.custom-bmr-input-native {
  flex: 1;
  width: 100%;
  height: 44px;
  font-size: 18px;
  font-weight: 700;
  color: #222222;
}

.custom-bmr-unit-text {
  flex-shrink: 0;
  font-size: 14px;
  color: #666666;
}

.custom-bmr-hint-row {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  align-items: center;
}

.custom-bmr-hint-text {
  font-size: 12px;
  color: #888888;
  line-height: 1.5;
}

.restore-budget-link {
  font-size: 12px;
  font-weight: 600;
  color: #5fa854;
  line-height: 1.5;
  padding: 4px 0;
}

.custom-bmr-action-row {
  display: flex;
  flex-direction: row;
  gap: 12px;
  margin-top: 4px;
}

.custom-bmr-btn {
  flex: 1;
  height: 44px;
  border-radius: 22px;
  display: flex;
  align-items: center;
  justify-content: center;
  box-sizing: border-box;
}

.custom-bmr-btn--cancel {
  background-color: #ffffff;
  border: 1.5px solid #5fa854;
}

.custom-bmr-btn--confirm {
  background-color: #d5e7b1;
  border: 1px solid #9ebc86;
}

.custom-bmr-btn-text {
  font-size: 15px;
  font-weight: 600;
}

.custom-bmr-btn-text--cancel {
  color: #5fa854;
}

.custom-bmr-btn-text--confirm {
  font-weight: 700;
  color: #222222;
}
</style>
