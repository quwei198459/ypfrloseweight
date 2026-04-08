<template>
  <view v-if="visible" class="overlay" @click="emit('update:visible', false)">
    <view class="popup" @click.stop>
      <text class="popup-title">运动记录</text>

      <view class="sport-summary">
        <view class="thumb" />
        <view class="text-col">
          <text class="sport-name">{{ sportName }}</text>
          <text class="sport-calories">{{ caloriesText }}</text>
        </view>
      </view>

      <view class="fields">
        <view class="field-row">
          <text class="field-label">运动时长</text>
          <view class="duration-row">
            <input
              class="field-input"
              type="number"
              v-model="localDuration"
              placeholder="请输入运动时长"
            />
            <text class="unit-text">分钟</text>
          </view>
        </view>
      </view>

      <view class="actions">
        <button class="btn cancel" @click="emit('cancel')">取消</button>
        <button class="btn confirm" @click="onConfirm">确定</button>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

const props = defineProps<{
  visible: boolean
  sportName: string
  caloriesText: string
  duration?: string
}>()

const emit = defineEmits<{
  (e: 'update:visible', value: boolean): void
  (e: 'cancel'): void
  (e: 'confirm', duration: string): void
}>()

const localDuration = ref(props.duration || '')

watch(
  () => props.visible,
  v => {
    if (v) localDuration.value = props.duration || ''
  }
)

const onConfirm = () => {
  emit('confirm', localDuration.value)
  emit('update:visible', false)
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
  padding: 32px 24px 20px;
  box-sizing: border-box;
  position: relative;
  flex-shrink: 0;
  max-height: calc(100vh - 160px);
  overflow-y: auto;
  display: flex;
  flex-direction: column;
}

.panda-decor {
  position: absolute;
  left: -20px;
  top: -30px;
  width: 80px;
  height: 80px;
  border-radius: 40px;
  background: #ffffff;
  border: 4px solid #1a1a1a;
}

.popup-title {
  font-size: 18px;
  font-weight: 700;
  color: #222222;
  text-align: left;
  margin: 0 0 16px;
}

.sport-summary {
  border-radius: 16px;
  background: #f7fbf7;
  padding: 8px 12px;
  display: flex;
  align-items: center;
  gap: 12px;
}

.thumb {
  width: 48px;
  height: 48px;
  border-radius: 12px;
  background: #e6f0ff;
}

.text-col {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.sport-name {
  font-size: 14px;
  font-weight: 600;
  color: #222222;
}

.sport-calories {
  font-size: 12px;
  color: #8a8a8a;
}

.fields {
  margin-top: 14px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.field-row {
  display: flex;
  align-items: center;
  gap: 12px;
}

.field-label {
  width: 64px;
  font-size: 13px;
  color: #222222;
}

.duration-row {
  flex: 1;
  display: flex;
  align-items: center;
  gap: 8px;
}

.field-input {
  flex: 1;
  height: 40px;
  border-radius: 12px;
  border: 1px solid #e0e0e0;
  padding: 0 12px;
  font-size: 13px;
  box-sizing: border-box;
}

.unit-text {
  font-size: 13px;
  color: #666666;
}

.actions {
  margin-top: 18px;
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
