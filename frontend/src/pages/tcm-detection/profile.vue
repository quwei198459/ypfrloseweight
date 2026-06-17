<template>
  <view class="tcm-page">
    <view class="card">
      <text class="title">确认检测资料</text>
      <text class="subtitle">资料仅用于生成本次中医体检报告，可按实际情况修改。</text>

      <view class="form-row">
        <text class="label">姓名</text>
        <input class="input" v-model="form.name" placeholder="请输入姓名或昵称" />
      </view>
      <view class="form-row">
        <text class="label">性别</text>
        <picker :range="genderOptions" range-key="label" @change="onGenderChange">
          <view class="picker-value">{{ genderLabel }}</view>
        </picker>
      </view>
      <view class="form-row">
        <text class="label">出生日期</text>
        <picker mode="date" :value="form.birthday" @change="onBirthdayChange">
          <view class="picker-value">{{ form.birthday || '请选择出生日期' }}</view>
        </picker>
      </view>
      <view class="form-row">
        <text class="label">年龄</text>
        <input class="input" v-model="ageText" type="number" placeholder="请输入年龄" />
      </view>
      <view class="form-row">
        <text class="label">居住地</text>
        <picker
          mode="multiSelector"
          :range="regionRange"
          :value="regionIndex"
          @columnchange="onResidenceColumnChange"
          @change="onResidenceChange"
        >
          <view class="picker-value">{{ residenceLabel || '请选择居住地' }}</view>
        </picker>
      </view>
    </view>

    <view class="agreement" @click="agreed = !agreed">
      <view class="checkbox" :class="{ checked: agreed }">{{ agreed ? '✓' : '' }}</view>
      <text class="agreement-text">我已阅读并同意上传舌象与面象图片用于本次中医体质辨识分析。</text>
    </view>

    <button class="primary-btn" @click="submit">下一步</button>
  </view>
</template>

<script setup lang="ts">
import { computed, reactive, ref } from 'vue'
import { onShow } from '@dcloudio/uni-app'
import { getRegionTree, type RegionAreaNode } from '@/api/region'
import { useUserStore } from '@/stores/user'

const STORAGE_PROFILE = 'tcm_detection_profile'
const userStore = useUserStore()
const agreed = ref(false)
const ageText = ref('')
const regionTree = ref<RegionAreaNode[]>([])
const regionIndex = ref([0, 0, 0])

const genderOptions = [
  { label: '未知', value: 0 },
  { label: '男', value: 1 },
  { label: '女', value: 2 },
]

const form = reactive({
  name: '',
  gender: 0,
  birthday: '',
  residenceProvince: '',
  residenceCity: '',
  residenceDistrict: '',
})

const genderLabel = computed(() => genderOptions.find((g) => g.value === form.gender)?.label || '未知')
const residenceLabel = computed(() => [
  form.residenceProvince,
  form.residenceCity,
  form.residenceDistrict,
].filter(Boolean).join(' '))

const regionRange = computed(() => {
  const provinces = regionTree.value
  const province = provinces[regionIndex.value[0]]
  const cities = province?.children || []
  const city = cities[regionIndex.value[1]]
  const districts = city?.children || []
  return [
    provinces.map((item) => item.name),
    cities.map((item) => item.name),
    districts.map((item) => item.name),
  ]
})

onShow(async () => {
  try {
    if (regionTree.value.length === 0) {
      regionTree.value = await getRegionTree()
    }
  } catch {
    regionTree.value = []
  }

  let user = userStore.userInfo
  if (!user && userStore.token) {
    try { user = await userStore.fetchUserProfile() } catch { user = null }
  }
  if (user) {
    form.name = form.name || user.nickname || ''
    form.gender = user.gender || 0
    form.birthday = form.birthday || user.birthday || ''
    ageText.value = ageText.value || (user.age ? String(user.age) : '')
    form.residenceProvince = form.residenceProvince || user.residenceProvince || ''
    form.residenceCity = form.residenceCity || user.residenceCity || ''
    form.residenceDistrict = form.residenceDistrict || user.residenceDistrict || ''
    syncRegionIndexFromForm()
  }
})

function syncRegionIndexFromForm() {
  const provinces = regionTree.value
  const p = Math.max(0, provinces.findIndex((item) => item.name === form.residenceProvince))
  const cities = provinces[p]?.children || []
  const c = Math.max(0, cities.findIndex((item) => item.name === form.residenceCity))
  const districts = cities[c]?.children || []
  const d = Math.max(0, districts.findIndex((item) => item.name === form.residenceDistrict))
  regionIndex.value = [p, c, d]
}

function onGenderChange(e: { detail: { value: number | string } }) {
  const idx = Number(e.detail.value)
  form.gender = genderOptions[idx]?.value ?? 0
}

function onBirthdayChange(e: { detail: { value: string } }) {
  form.birthday = e.detail.value
}

function onResidenceColumnChange(e: { detail: { column: number; value: number } }) {
  const next = [...regionIndex.value]
  next[e.detail.column] = e.detail.value
  if (e.detail.column === 0) {
    next[1] = 0
    next[2] = 0
  } else if (e.detail.column === 1) {
    next[2] = 0
  }
  regionIndex.value = next
}

function onResidenceChange(e: { detail: { value: number[] } }) {
  const value = e.detail.value
  regionIndex.value = value
  const province = regionTree.value[value[0]]
  const city = province?.children?.[value[1]]
  const district = city?.children?.[value[2]]
  form.residenceProvince = province?.name || ''
  form.residenceCity = city?.name || ''
  form.residenceDistrict = district?.name || ''
}

function submit() {
  if (!agreed.value) {
    uni.showToast({ title: '请先确认检测协议', icon: 'none' })
    return
  }
  const age = Number(ageText.value)
  const payload = {
    name: form.name.trim(),
    gender: form.gender,
    birthday: form.birthday || undefined,
    age: Number.isFinite(age) && age > 0 ? Math.floor(age) : undefined,
    residence: residenceLabel.value,
  }
  uni.setStorageSync(STORAGE_PROFILE, payload)
  uni.navigateTo({ url: '/pages/tcm-detection/camera' })
}
</script>

<style lang="scss" scoped>
.tcm-page { min-height: 100vh; padding: 18px 16px 32px; background: #f7fbf7; box-sizing: border-box; }
.card { padding: 20px 18px; border-radius: 22px; background: #fff; border: 1px solid #edf1e7; }
.title { display: block; font-size: 22px; font-weight: 900; color: #1f2a1f; }
.subtitle { display: block; margin-top: 8px; font-size: 13px; line-height: 1.6; color: #7a857a; }
.form-row { margin-top: 18px; padding-bottom: 12px; border-bottom: 1px solid #f0f2ee; }
.label { display: block; margin-bottom: 8px; font-size: 13px; color: #607060; font-weight: 700; }
.input, .picker-value { height: 36px; line-height: 36px; font-size: 16px; color: #222; }
.agreement { margin-top: 18px; display: flex; align-items: flex-start; }
.checkbox { width: 20px; height: 20px; border-radius: 50%; border: 1px solid #9ebc86; color: #fff; display: flex; align-items: center; justify-content: center; font-size: 13px; flex-shrink: 0; }
.checkbox.checked { background: #9ebc86; }
.agreement-text { margin-left: 8px; font-size: 13px; line-height: 1.5; color: #607060; }
.primary-btn { margin-top: 24px; height: 48px; border-radius: 24px; background: #9ebc86; color: #fff; font-size: 16px; font-weight: 800; }
</style>
