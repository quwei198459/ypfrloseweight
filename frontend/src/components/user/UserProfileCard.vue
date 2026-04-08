<template>
  <view class="profile-card">
    <!-- #ifdef MP-WEIXIN -->
    <view class="profile-row profile-row--avatar">
      <text class="profile-row__label">我的头像</text>
      <view class="profile-row__right">
        <button class="avatar-hit" open-type="chooseAvatar" hover-class="none" @chooseavatar="onChooseAvatar">
          <image v-if="avatarSrc" class="avatar-img" :src="avatarSrc" mode="aspectFill" />
          <view v-else class="avatar-placeholder" />
        </button>
        <text class="chevron">›</text>
      </view>
    </view>
    <!-- #endif -->
    <!-- #ifndef MP-WEIXIN -->
    <view class="profile-row profile-row--avatar" @click="$emit('avatar-click')">
      <text class="profile-row__label">我的头像</text>
      <view class="profile-row__right">
        <image v-if="avatarSrc" class="avatar-img" :src="avatarSrc" mode="aspectFill" />
        <view v-else class="avatar-placeholder" />
        <text class="chevron">›</text>
      </view>
    </view>
    <!-- #endif -->

    <view class="profile-divider" />

    <view class="profile-row profile-row--nick">
      <text class="profile-row__label">我的昵称</text>
      <view class="profile-row__right profile-row__right--nick">
        <!-- #ifdef MP-WEIXIN -->
        <!-- 微信推荐：type=nickname，由用户在系统面板中填写/选用昵称，无单独静默接口 -->
        <input
          class="nick-input"
          type="nickname"
          :value="nickname"
          maxlength="64"
          adjust-position
          confirm-type="done"
          placeholder="轻点此处，使用微信昵称能力"
          placeholder-class="nick-placeholder"
          @blur="onNickBlur"
          @confirm="onNickConfirm"
          @input="onNickInput"
        />
        <!-- #endif -->
        <!-- #ifndef MP-WEIXIN -->
        <input
          class="nick-input"
          :value="nickname"
          placeholder="填写昵称"
          placeholder-class="nick-placeholder"
          @blur="onNickBlurPlain"
          @input="onNickInputPlain"
        />
        <!-- #endif -->
        <text class="chevron">›</text>
      </view>
    </view>
  </view>
</template>

<script setup lang="ts">
const props = defineProps<{
  nickname: string
  /** 展示用完整 URL 或临时路径 */
  avatarSrc?: string
}>()

const emit = defineEmits<{
  (e: 'update:nickname', v: string): void
  (e: 'chooseavatar', detail: { avatarUrl?: string }): void
  (e: 'avatar-click'): void
}>()

function onChooseAvatar(e: { detail?: { avatarUrl?: string } }) {
  emit('chooseavatar', e.detail ?? {})
}

function onNickBlur(e: { detail?: { value?: string } }) {
  const v = e.detail?.value ?? props.nickname
  emit('update:nickname', v.trim())
}

function onNickConfirm(e: { detail?: { value?: string } }) {
  const v = e.detail?.value ?? props.nickname
  emit('update:nickname', v.trim())
}

function onNickInput(e: { detail?: { value?: string } }) {
  emit('update:nickname', (e.detail?.value ?? '').trim())
}

function onNickBlurPlain(e: { detail?: { value?: string } }) {
  emit('update:nickname', (e.detail?.value ?? props.nickname).trim())
}

function onNickInputPlain(e: { detail?: { value?: string } }) {
  emit('update:nickname', (e.detail?.value ?? '').trim())
}
</script>

<style lang="scss" scoped>
@use './user-variables.scss' as *;

.profile-card {
  background: $user-card-bg;
  border-radius: $user-card-radius;
  box-shadow: $user-card-shadow;
  padding: 8rpx 32rpx;
}

.profile-row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  min-height: 112rpx;
  padding: 12rpx 0;
  box-sizing: border-box;
}

.profile-row__label {
  font-size: $user-label-size;
  color: $user-text-primary;
  font-weight: normal;
  flex-shrink: 0;
}

.profile-row__right {
  display: flex;
  flex-direction: row;
  align-items: center;
  gap: 16rpx;
  min-width: 0;
  flex: 1;
  justify-content: flex-end;
}

.profile-row__right--nick {
  max-width: 420rpx;
}

.avatar-hit {
  margin: 0;
  padding: 0;
  background: transparent;
  border: none;
  line-height: 0;
}

.avatar-hit::after {
  border: none;
}

.avatar-img {
  width: 80rpx;
  height: 80rpx;
  border-radius: 50%;
  display: block;
}

.avatar-placeholder {
  width: 80rpx;
  height: 80rpx;
  border-radius: 50%;
  background: #e8e8e8;
  border: 2rpx dashed #c8e6d0;
}

.nick-input {
  flex: 1;
  min-width: 0;
  text-align: right;
  font-size: $user-value-size;
  color: $user-text-secondary;
  height: 64rpx;
  line-height: 64rpx;
}

.nick-placeholder {
  color: #bbbbbb;
  font-size: $user-value-size;
}

.chevron {
  font-size: 36rpx;
  color: $user-chevron;
  line-height: 1;
  flex-shrink: 0;
}

.profile-divider {
  height: 2rpx;
  background: $user-row-divider;
  width: 100%;
}
</style>
