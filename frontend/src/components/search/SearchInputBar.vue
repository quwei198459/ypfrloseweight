<template>
  <view class="search-input-bar">
    <view class="search-icon-wrap">
      <image
        class="search-icon-image"
        src="/static/icons/search.png"
        mode="aspectFit"
      />
    </view>
    <input
      class="search-input"
      type="text"
      confirm-type="search"
      :value="modelValue"
      :placeholder="placeholder"
      @input="onInput"
    />
    <view class="camera-entry-button" @click.stop="emit('camera')">
      <image
        class="camera-icon-image"
        src="/static/icons/camera.png"
        mode="aspectFit"
      />
    </view>
  </view>
</template>

<script setup lang="ts">
withDefaults(
  defineProps<{
    modelValue: string
    placeholder?: string
  }>(),
  {
    placeholder: '10w+ 食物库热量查询',
  },
)

const emit = defineEmits<{
  (e: 'update:modelValue', v: string): void
  (e: 'camera'): void
}>()

/** uni-app input：值在 e.detail.value；模板类型按 DOM Event 推断，此处做窄化 */
const onInput = (e: Event) => {
  const detail = (e as unknown as { detail?: { value?: string } }).detail
  emit('update:modelValue', detail?.value ?? '')
}
</script>

<style lang="scss" scoped>
/* 设计稿 search-input-bar：圆角 36，padding 7+11，内部 gap 6，相机区 32×32 */
.search-input-bar {
  display: flex;
  flex-direction: row;
  align-items: center;
  min-height: 64rpx;
  padding: 6px 12px 6rpx 24px;
  background: #ffffff;
  border-radius: 72rpx;
  box-sizing: border-box;
  width: 100%;
  min-width: 0;
  gap: 12rpx;
}

.search-icon-wrap {
  width: 36rpx;
  height: 36rpx;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.search-icon-image {
  width: 46rpx;
  height: 46rpx;
  display: block;
}

.search-input {
  flex: 1;
  min-width: 0;
  font-size: 28rpx;
  color: #212121;
  height: 44rpx;
  line-height: 44rpx;
}

.camera-entry-button {
  width: 64rpx;
  height: 64rpx;
  border-radius: 16rpx;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.camera-icon-image {
  width: 46rpx;
  height: 46rpx;
  display: block;
}
</style>
