<template>
  <view v-if="visible" class="overlay" @click="onMaskClick">
    <view class="popup" @click.stop>
      <text class="popup-title">添加自定义食物</text>

      <view class="fields">
        <view class="field-row">
          <text class="field-label">名称</text>
          <input
            class="field-input"
            type="text"
            v-model="localName"
            placeholder="请输入食物名称"
          />
        </view>

        <view class="field-row">
          <text class="field-label">重量</text>
          <view class="weight-row">
            <input
              class="field-input"
              type="number"
              v-model="localWeight"
              placeholder="请输入重量"
            />
            <text class="unit-text">g</text>
            <view class="weight-help">
              <text class="help-text">估重</text>
              <view class="help-icon">
                <text class="help-symbol">?</text>
              </view>
            </view>
          </view>
        </view>

        <view class="field-row">
          <text class="field-label">热量</text>
          <input
            class="field-input"
            type="number"
            v-model="localCalories"
            placeholder="该份量总热量(千卡)"
          />
        </view>
      </view>

      <view class="actions">
        <button class="btn cancel" @click="emit('cancel')">取消</button>
        <button
          class="btn confirm"
          :disabled="Boolean(confirmLoading)"
          @click="onConfirm"
        >
          {{ confirmLoading ? '保存中…' : '确定' }}
        </button>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

const props = defineProps<{
  visible: boolean
  name?: string
  weight?: string
  calories?: string
  /** 提交中：禁止重复点确定，由父组件在接口返回后置 false */
  confirmLoading?: boolean
}>()

const emit = defineEmits<{
  (e: 'update:visible', value: boolean): void
  (e: 'cancel'): void
  (e: 'confirm', payload: { name: string; weight: string; calories: string }): void
}>()

const localName = ref(props.name || '')
const localWeight = ref(props.weight || '')
const localCalories = ref(props.calories || '')

watch(
  () => props.visible,
  val => {
    if (val) {
      localName.value = props.name || ''
      localWeight.value = props.weight || ''
      localCalories.value = props.calories || ''
    }
  }
)

const onMaskClick = () => {
  emit('update:visible', false)
}

const onConfirm = () => {
  if (props.confirmLoading) return
  emit('confirm', {
    name: localName.value,
    weight: localWeight.value,
    calories: localCalories.value,
  })
}
</script>

<style scoped lang="scss">
.overlay {
  position: fixed;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 50;
}

.popup {
  width: 320px;
  border-radius: 24px;
  background: #ffffff;
  padding: 34px 24px 22px;
  box-sizing: border-box;
  position: relative;
  flex-shrink: 0; // 防止弹层在 flex 容器中被压缩，导致间距改动失效
  max-height: calc(100vh - 160px);
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}

.popup-title {
  font-size: 18px;
  font-weight: 700;
  color: #222222;
  text-align: left;
  margin: 0 0 18px;
}

.field-row {
  display: flex;
  align-items: center;
  gap: 8px;
}

.fields {
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.field-label {
  width: 40px;
  font-size: 13px;
  color: #222222;
}

.field-input {
  flex: 1;
  height: 40px;
  border-radius: 12px;
  border: 1px solid #e0e0e0;
  padding: 0 6px;
  font-size: 13px;
  box-sizing: border-box;
}

.weight-row {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 6px;
}

.unit-text {
  font-size: 13px;
  color: #666666;
}

.weight-help {
  display: flex;
  align-items: center;
  gap: 6px;
  flex-shrink: 0;
}

.help-text {
  font-size: 13px;
  color: #6f8a52;
  font-weight: 600;
}

.help-icon {
  width: 18px;
  height: 18px;
  border-radius: 9px;
  border: 1px solid #c9c9c9;
  display: flex;
  align-items: center;
  justify-content: center;
}

.help-symbol {
  font-size: 12px;
  color: #9a9a9a;
  line-height: 1;
}

.actions {
  margin-top: 22px;
  display: flex;
  justify-content: space-between;
  gap: 12px;
}

.btn {
  flex: 1;
  height: 44px;
  border-radius: 22px;
  font-size: 15px;
  font-weight: 600;
}

.btn.cancel {
  background: #ffffff;
  border: 2px solid #7a8f5a;
  color: #7a8f5a;
}

.btn.confirm {
  background: #bbd87a;
  border: 2px solid #7a8f5a;
  color: #4b5b2d;
}
</style>

