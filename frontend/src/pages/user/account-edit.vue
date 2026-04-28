<template>
  <view class="profile-page">
    <scroll-view scroll-y class="profile-page__scroll" :show-scrollbar="false">
      <UserProfileCard
        :nickname="profileData.nickname"
        :avatar-src="displayAvatarSrc"
        @update:nickname="(v) => (profileData.nickname = v)"
        @chooseavatar="onChooseWxAvatar"
        @avatar-click="onPickAvatarFallback"
      />

      <!-- #ifdef MP-WEIXIN -->
      <text class="wx-nick-hint">昵称与头像分别点击同步获取微信信息</text>
      <text class="wx-nick-hint">修改以下信息会更新每日热量预算</text>
      <!-- #endif -->

      <view class="phone-card">
        <view class="phone-card__row">
          <text class="phone-card__label">手机号</text>
          <text class="phone-card__val" :class="{ 'phone-card__val--muted': profileData.phoneDisplay === '未绑定' }">
            {{ profileData.phoneDisplay }}
          </text>
        </view>
        <!-- #ifdef MP-WEIXIN -->
        <button
          v-if="profileData.phoneDisplay === '未绑定'"
          class="phone-bind-btn phone-bind-btn--emphasis"
          open-type="getPhoneNumber"
          hover-class="none"
          @getphonenumber="onPhoneAuth"
        >
          <text class="phone-bind-btn__txt">微信授权手机号</text>
        </button>
        <!-- #endif -->
      </view>

      <UserInfoFormCard
        :gender="profileData.gender"
        :age="profileData.age"
        :height="profileData.height"
        :current-weight="profileData.currentWeight"
        :target-weight="profileData.targetWeight"
        :target-date="profileData.targetDate"
        @gender="openGender"
        @age="openAge"
        @height="openHeight"
        @weight="openWeight"
        @target-weight="openTargetWeight"
        @target-date="openTargetDate"
      />

      <view class="profile-page__scroll-gap" />
    </scroll-view>

    <view class="profile-footer">
      <view class="profile-save" @click="onSave">
        <text class="profile-save__txt">保存个人信息</text>
      </view>
    </view>

    <UserPickerPopup
      v-model="showGenderPopup"
      title="选择性别"
      :options="genderOpts"
      :index="genderIndex"
      @update:index="(i) => (genderIndex = i)"
      @confirm-wheel="onConfirmGender"
    />

    <UserPickerPopup
      v-model="showAgePopup"
      title="选择年龄"
      :options="AGE_OPTIONS"
      :index="ageIndex"
      @update:index="(i) => (ageIndex = i)"
      @confirm-wheel="onConfirmAge"
    />

    <UserPickerPopup
      v-model="showHeightPopup"
      title="选择身高"
      :options="HEIGHT_OPTIONS"
      :index="heightIndex"
      @update:index="(i) => (heightIndex = i)"
      @confirm-wheel="onConfirmHeight"
    />

    <UserPickerPopup
      v-model="showWeightPopup"
      title="选择体重"
      :options="WEIGHT_JIN_OPTIONS"
      :index="weightIndex"
      @update:index="(i) => (weightIndex = i)"
      @confirm-wheel="onConfirmWeight"
    />

    <UserPickerPopup
      v-model="showTargetWeightPopup"
      title="选择目标体重"
      :options="WEIGHT_JIN_OPTIONS"
      :index="targetWeightIndex"
      @update:index="(i) => (targetWeightIndex = i)"
      @confirm-wheel="onConfirmTargetWeight"
    />

    <UserPickerPopup
      v-model="showTargetDatePopup"
      title="达成时间"
      subtitle="每周减重0.8斤，预计2026年5月5日完成"
      :options="WEEK_OPTIONS"
      :index="weekIndex"
      @update:index="(i) => (weekIndex = i)"
      @confirm-wheel="onConfirmWeek"
    />
  </view>
</template>

<script setup lang="ts">
import { onShow } from '@dcloudio/uni-app'
import { storeToRefs } from 'pinia'
import { computed, ref } from 'vue'
import { fetchCurrentUser } from '@/api/loseweight'
import { useUserStore } from '@/stores/user'
import {
  genderLabelToCode,
  parseAgeLabel,
  parseHeightCm,
  parseTargetDateIso,
  parseWeightKgFromJinLabel,
} from '@/utils/profilePayload'
import { useUserProfileStore } from '../../stores/userProfile'
import UserProfileCard from '../../components/user/UserProfileCard.vue'
import UserInfoFormCard from '../../components/user/UserInfoFormCard.vue'
import UserPickerPopup from '../../components/user/UserPickerPopup.vue'
import {
  AGE_OPTIONS,
  GENDER_OPTIONS,
  HEIGHT_OPTIONS,
  indexOfLabel,
  WEEK_OPTIONS,
  WEIGHT_JIN_OPTIONS,
} from '../../constants/userProfilePickers'

const store = useUserProfileStore()
const userStore = useUserStore()
const {
  profileData,
  showGenderPopup,
  showAgePopup,
  showHeightPopup,
  showWeightPopup,
  showTargetWeightPopup,
  showTargetDatePopup,
} = storeToRefs(store)

/** 微信小程序头像临时路径，保存时转 Base64 上传 */
const pendingAvatarPath = ref('')

const displayAvatarSrc = computed(() => {
  if (pendingAvatarPath.value) return pendingAvatarPath.value
  return profileData.value.avatar || ''
})

const genderOpts = [...GENDER_OPTIONS]

const genderIndex = ref(indexOfLabel(genderOpts, profileData.value.gender))
const ageIndex = ref(indexOfLabel(AGE_OPTIONS, profileData.value.age))
const heightIndex = ref(indexOfLabel(HEIGHT_OPTIONS, profileData.value.height))
const weightIndex = ref(indexOfLabel(WEIGHT_JIN_OPTIONS, profileData.value.currentWeight))
const targetWeightIndex = ref(indexOfLabel(WEIGHT_JIN_OPTIONS, profileData.value.targetWeight))
const weekIndex = ref(indexOfLabel(WEEK_OPTIONS, '8周'))

onShow(async () => {
  try {
    if (userStore.token) {
      const u = await userStore.fetchUserProfile()
      if (u) store.applyFromApiUser(u)
    } else {
      const u = await fetchCurrentUser()
      store.applyFromApiUser(u)
    }
  } catch {
    /* 未登录或网络失败时保留本地 store */
  }
})

function readFileAsBase64(filePath: string): Promise<string | undefined> {
  return new Promise((resolve) => {
    uni.getFileSystemManager().readFile({
      filePath,
      encoding: 'base64',
      success: (r) => {
        const d = r.data
        resolve(typeof d === 'string' ? d : undefined)
      },
      fail: () => resolve(undefined),
    })
  })
}

function onChooseWxAvatar(e: { avatarUrl?: string }) {
  const u = e.avatarUrl
  if (u) pendingAvatarPath.value = u
}

function onPickAvatarFallback() {
  uni.chooseImage({
    count: 1,
    sizeType: ['compressed'],
    sourceType: ['album', 'camera'],
    success: (res) => {
      const p = res.tempFilePaths?.[0]
      if (p) pendingAvatarPath.value = p
    },
  })
}

async function onPhoneAuth(e: { detail?: { errMsg?: string; code?: string } }) {
  const d = e.detail
  if (!d?.errMsg || !d.errMsg.includes('getPhoneNumber:ok')) {
    uni.showToast({ title: '未授权手机号', icon: 'none' })
    return
  }
  if (!d.code) {
    uni.showToast({ title: '请升级微信或基础库以支持手机号', icon: 'none' })
    return
  }
  if (!userStore.token) {
    uni.showToast({ title: '请先登录', icon: 'none' })
    return
  }
  try {
    await userStore.bindPhone(d.code)
    uni.showToast({ title: '绑定成功', icon: 'success' })
    if (userStore.userInfo) store.applyFromApiUser(userStore.userInfo)
  } catch (err: unknown) {
    uni.showToast({ title: err instanceof Error ? err.message : '绑定失败', icon: 'none' })
  }
}

function openGender() {
  genderIndex.value = indexOfLabel(genderOpts, profileData.value.gender)
  showGenderPopup.value = true
}

function openAge() {
  ageIndex.value = indexOfLabel(AGE_OPTIONS, profileData.value.age)
  showAgePopup.value = true
}

function openHeight() {
  heightIndex.value = indexOfLabel(HEIGHT_OPTIONS, profileData.value.height)
  showHeightPopup.value = true
}

function openWeight() {
  weightIndex.value = indexOfLabel(WEIGHT_JIN_OPTIONS, profileData.value.currentWeight)
  showWeightPopup.value = true
}

function openTargetWeight() {
  targetWeightIndex.value = indexOfLabel(WEIGHT_JIN_OPTIONS, profileData.value.targetWeight)
  showTargetWeightPopup.value = true
}

function openTargetDate() {
  const t = profileData.value.targetDate
  const m = t.match(/\d+周/)
  weekIndex.value = m ? indexOfLabel(WEEK_OPTIONS, m[0]) : indexOfLabel(WEEK_OPTIONS, '8周')
  showTargetDatePopup.value = true
}

function onConfirmGender(v: string) {
  profileData.value.gender = v
}

function onConfirmAge(v: string) {
  profileData.value.age = v
}

function onConfirmHeight(v: string) {
  profileData.value.height = v
}

function onConfirmWeight(v: string) {
  profileData.value.currentWeight = v
}

function onConfirmTargetWeight(v: string) {
  profileData.value.targetWeight = v
}

function onConfirmWeek(v: string) {
  profileData.value.targetDate = v
}

async function onSave() {
  const nick = profileData.value.nickname?.trim()
  if (!nick) {
    uni.showToast({ title: '请填写昵称', icon: 'none' })
    return
  }
  const gender = genderLabelToCode(profileData.value.gender)
  if (gender == null) {
    uni.showToast({ title: '请选择性别', icon: 'none' })
    return
  }
  const age = parseAgeLabel(profileData.value.age)
  if (age == null || age < 1) {
    uni.showToast({ title: '请选择年龄', icon: 'none' })
    return
  }
  const heightCm = parseHeightCm(profileData.value.height)
  if (heightCm == null || heightCm <= 0) {
    uni.showToast({ title: '请选择身高', icon: 'none' })
    return
  }
  const currentWeightKg = parseWeightKgFromJinLabel(profileData.value.currentWeight)
  if (currentWeightKg == null || currentWeightKg <= 0) {
    uni.showToast({ title: '请选择最新体重', icon: 'none' })
    return
  }
  const targetWeightKg = parseWeightKgFromJinLabel(profileData.value.targetWeight)
  if (targetWeightKg == null || targetWeightKg <= 0) {
    uni.showToast({ title: '请选择目标体重', icon: 'none' })
    return
  }
  const targetDate = parseTargetDateIso(profileData.value.targetDate)
  if (!targetDate) {
    uni.showToast({ title: '请选择目标达成时间', icon: 'none' })
    return
  }
  if (!userStore.token) {
    uni.showToast({ title: '请先登录', icon: 'none' })
    return
  }

  let avatarBase64: string | undefined
  if (pendingAvatarPath.value) {
    const b64 = await readFileAsBase64(pendingAvatarPath.value)
    if (b64) avatarBase64 = `data:image/jpeg;base64,${b64}`
  }

  try {
    uni.showLoading({ title: '保存中', mask: true })
    const info = userStore.userInfo
    const activityLevel =
      info?.activityLevel != null && info.activityLevel >= 1 && info.activityLevel <= 5
        ? Math.floor(Number(info.activityLevel))
        : undefined
    const payload: Parameters<typeof userStore.updateUserProfile>[0] = {
      nickname: nick,
      gender,
      age,
      heightCm,
      currentWeightKg,
      targetWeightKg,
      targetDate,
      avatarBase64,
    }
    if (activityLevel != null) {
      payload.activityLevel = activityLevel
    }
    const u = await userStore.updateUserProfile(payload)
    pendingAvatarPath.value = ''
    store.applyFromApiUser(u)
    uni.hideLoading()
    uni.showModal({
      title: '保存成功',
      content: '已根据您的个人信息，更新了每日热量预算。',
      showCancel: false,
      confirmText: '确定',
      success: () => {
        if (u.profileCompleted) {
          uni.reLaunch({ url: '/pages/user/index' })
        }
      },
    })
  } catch (err: unknown) {
    uni.hideLoading()
    uni.showToast({ title: err instanceof Error ? err.message : '保存失败', icon: 'none' })
  }
}
</script>

<style lang="scss" scoped>
@use '../../components/user/user-variables.scss' as *;

.profile-page {
  height: 100vh;
  min-height: 100vh;
  background: $user-page-bg;
  box-sizing: border-box;
  display: flex;
  flex-direction: column;
}

.profile-page__scroll {
  flex: 1;
  height: 0;
  padding: 24rpx 32rpx 0;
  box-sizing: border-box;
}

.wx-nick-hint {
  display: block;
  margin: 16rpx 8rpx 0;
  padding: 0 8rpx;
  font-size: 24rpx;
  color: $user-text-hint;
  line-height: 1.45;
}

.profile-hint {
  display: block;
  margin: 28rpx 8rpx 20rpx;
  font-size: $user-hint-size;
  color: $user-text-hint;
  line-height: 1.3;
}

.profile-page__scroll-gap {
  height: calc(200rpx + env(safe-area-inset-bottom));
}

.profile-footer {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 100;
  padding: 16rpx 32rpx;
  padding-bottom: calc(16rpx + env(safe-area-inset-bottom));
  background: linear-gradient(to top, $user-page-bg 80%, rgba(248, 248, 248, 0));
  box-sizing: border-box;
}

.profile-save {
  width: 100%;
  max-width: 640rpx;
  margin: 0 auto;
  height: 96rpx;
  border-radius: 48rpx;
  background: $user-save-bg;
  display: flex;
  align-items: center;
  justify-content: center;
}

.profile-save__txt {
  font-size: 32rpx;
  font-weight: 600;
  color: $user-save-text;
}

.phone-card {
  margin-top: 24rpx;
  background: $user-card-bg;
  border-radius: $user-card-radius;
  box-shadow: $user-card-shadow;
  padding: 24rpx 32rpx 28rpx;
  box-sizing: border-box;
}

.phone-card__row {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  gap: 16rpx;
}

.phone-card__label {
  font-size: $user-label-size;
  color: $user-text-primary;
  flex-shrink: 0;
}

.phone-card__val {
  font-size: 30rpx;
  font-weight: 600;
  color: $user-text-primary;
  text-align: right;
  flex: 1;
  min-width: 0;
}

.phone-card__val--muted {
  color: $user-text-hint;
  font-weight: 500;
}

.phone-bind-btn {
  width: 100%;
  margin-top: 24rpx;
  height: 96rpx;
  border-radius: 48rpx;
  background: $user-save-bg;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  border: none;
  box-sizing: border-box;
}

.phone-bind-btn--emphasis {
  border: 4rpx solid #5ba86d;
}

.phone-bind-btn__txt {
  font-size: 32rpx;
  font-weight: 600;
  color: $user-save-text;
}

.phone-bind-btn::after {
  border: none;
}
</style>
