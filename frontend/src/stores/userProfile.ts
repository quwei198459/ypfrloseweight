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
  /** 脱敏展示，未绑定为「未绑定」 */
  phoneDisplay: string
}

export const useUserProfileStore = defineStore('userProfile', {
  state: () => ({
    profileData: {
      avatar: '',
      nickname: '想瘦的3508',
      gender: '男',
      age: '25岁',
      height: '175cm',
      currentWeight: '160斤',
      targetWeight: '154斤',
      targetDate: '2026-05-05',
      phoneDisplay: '未绑定',
    } as ProfileData,
    showGenderPopup: false,
    showAgePopup: false,
    showHeightPopup: false,
    showWeightPopup: false,
    showTargetWeightPopup: false,
    showTargetDatePopup: false,
  }),
  actions: {
    closeAllPickers() {
      this.showGenderPopup = false
      this.showAgePopup = false
      this.showHeightPopup = false
      this.showWeightPopup = false
      this.showTargetWeightPopup = false
      this.showTargetDatePopup = false
    },
    /** 将后端用户资料写入展示字段（体重按「斤」展示：kg×2） */
    applyFromApiUser(user: AppUserDto) {
      const jin = (kg: number | null | undefined) => {
        if (kg == null) return '--'
        return `${(Number(kg) * 2).toFixed(1)}斤`
      }
      const genderLabel =
        user.gender === 1 ? '男' : user.gender === 2 ? '女' : '未知'
      this.profileData.nickname = user.nickname?.trim() || '用户'
      this.profileData.gender = genderLabel
      this.profileData.age =
        user.age != null && user.age > 0 ? `${user.age}岁` : '--'
      this.profileData.height =
        user.heightCm != null ? `${user.heightCm}cm` : '--'
      this.profileData.currentWeight = jin(user.currentWeightKg)
      this.profileData.targetWeight = jin(user.targetWeightKg)
      this.profileData.targetDate = user.targetDate || '--'
      if (user.avatarUrl && user.avatarUrl.trim()) {
        let av = user.avatarUrl.trim()
        if (!/^https?:\/\//i.test(av)) {
          av = API_BASE_URL + (av.startsWith('/') ? av : `/${av}`)
        }
        this.profileData.avatar = av
      }
      const p = user.phone
      if (p && p.length >= 7) {
        this.profileData.phoneDisplay = `${p.slice(0, 3)}****${p.slice(-4)}`
      } else if (p) {
        this.profileData.phoneDisplay = p
      } else {
        this.profileData.phoneDisplay = '未绑定'
      }
    },
  },
})
