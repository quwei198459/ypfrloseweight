import type { AppUserDto } from '@/api/types'
import { API_BASE_URL } from '@/config/api'
import { defineStore } from 'pinia'

export interface ProfileData {
  avatar: string
  nickname: string
  gender: string
  age: string
  height: string
  currentWeight: string
  targetWeight: string
  targetDate: string
  birthday: string
  residenceProvince: string
  residenceCity: string
  residenceDistrict: string
  /** 脱敏展示，未绑定为「未绑定」 */
  phoneDisplay: string
  /** 「我的」统计：餐次条数 */
  mealRecordCount: number
  /** 健康饮食（天），口径与后端一致 */
  healthyDietDays: number
  /** 加入天数；未拉到资料前为 null */
  joinedDays: number | null
  /** 最近一次称重距今天数；无称重记录为 null */
  weightRecordedDaysAgo: number | null
}

export const useUserProfileStore = defineStore('userProfile', {
  state: () => ({
    profileData: {
      avatar: '',
      nickname: '',
      gender: '男',
      age: '25岁',
      height: '175cm',
      currentWeight: '80.0公斤',
      targetWeight: '77.0公斤',
      targetDate: '2026-05-05',
      birthday: '',
      residenceProvince: '',
      residenceCity: '',
      residenceDistrict: '',
      phoneDisplay: '未绑定',
      mealRecordCount: 0,
      healthyDietDays: 0,
      joinedDays: null,
      weightRecordedDaysAgo: null,
    } as ProfileData,
    showGenderPopup: false,
    showAgePopup: false,
    showHeightPopup: false,
    showWeightPopup: false,
    showTargetWeightPopup: false,
    showTargetDatePopup: false,
  }),
  actions: {
    resetProfile() {
      this.profileData.avatar = ''
      this.profileData.nickname = ''
      this.profileData.gender = '男'
      this.profileData.age = '--'
      this.profileData.height = '--'
      this.profileData.currentWeight = '--'
      this.profileData.targetWeight = '--'
      this.profileData.targetDate = '--'
      this.profileData.birthday = ''
      this.profileData.residenceProvince = ''
      this.profileData.residenceCity = ''
      this.profileData.residenceDistrict = ''
      this.profileData.phoneDisplay = '未绑定'
      this.profileData.mealRecordCount = 0
      this.profileData.healthyDietDays = 0
      this.profileData.joinedDays = null
      this.profileData.weightRecordedDaysAgo = null
      this.closeAllPickers()
    },
    closeAllPickers() {
      this.showGenderPopup = false
      this.showAgePopup = false
      this.showHeightPopup = false
      this.showWeightPopup = false
      this.showTargetWeightPopup = false
      this.showTargetDatePopup = false
    },
    /** 将后端用户资料写入展示字段（体重按「公斤」展示） */
    applyFromApiUser(user: AppUserDto) {
      const kgLabel = (kg: number | null | undefined) => {
        if (kg == null) return '--'
        return `${Number(kg).toFixed(1)}公斤`
      }
      const genderLabel =
        user.gender === 1 ? '男' : user.gender === 2 ? '女' : '未知'
      this.profileData.nickname = user.nickname?.trim() || '用户'
      this.profileData.gender = genderLabel
      this.profileData.age =
        user.age != null && user.age > 0 ? `${user.age}岁` : '--'
      this.profileData.height =
        user.heightCm != null ? `${user.heightCm}cm` : '--'
      this.profileData.currentWeight = kgLabel(user.currentWeightKg)
      this.profileData.targetWeight = kgLabel(user.targetWeightKg)
      this.profileData.targetDate = user.targetDate || '--'
      this.profileData.birthday = user.birthday || ''
      this.profileData.residenceProvince = user.residenceProvince || ''
      this.profileData.residenceCity = user.residenceCity || ''
      this.profileData.residenceDistrict = user.residenceDistrict || ''
      if (user.avatarUrl && user.avatarUrl.trim()) {
        let av = user.avatarUrl.trim()
        if (!/^https?:\/\//i.test(av)) {
          av = API_BASE_URL + (av.startsWith('/') ? av : `/${av}`)
        }
        this.profileData.avatar = av
      } else {
        this.profileData.avatar = ''
      }
      const p = user.phone
      if (p && p.length >= 7) {
        this.profileData.phoneDisplay = `${p.slice(0, 3)}****${p.slice(-4)}`
      } else if (p) {
        this.profileData.phoneDisplay = p
      } else {
        this.profileData.phoneDisplay = '未绑定'
      }

      this.profileData.mealRecordCount =
        user.mealRecordCount != null && user.mealRecordCount >= 0 ? Math.floor(user.mealRecordCount) : 0
      this.profileData.healthyDietDays =
        user.healthyDietDays != null && user.healthyDietDays >= 0
          ? Math.floor(user.healthyDietDays)
          : 0
      this.profileData.joinedDays =
        user.joinedDays != null && user.joinedDays >= 1 ? Math.floor(user.joinedDays) : null
      this.profileData.weightRecordedDaysAgo =
        user.weightRecordedDaysAgo != null && user.weightRecordedDaysAgo >= 0
          ? Math.floor(user.weightRecordedDaysAgo)
          : null
    },
  },
})
