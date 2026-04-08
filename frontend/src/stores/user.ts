import type { AppUserDto, UpdateProfilePayload, WxLoginResponse } from '@/api/types'
import { wxLoginByCode } from '@/api/auth'
import { bindPhoneByCode, getUserProfile, updateUserProfile } from '@/api/user'
import {
  STORAGE_OPENID,
  STORAGE_PROFILE_COMPLETED,
  STORAGE_TOKEN,
  STORAGE_USER_ID,
} from '@/config/api'
import { defineStore } from 'pinia'

function readStr(key: string): string {
  try {
    const v = uni.getStorageSync(key)
    return v != null && v !== '' ? String(v) : ''
  } catch {
    return ''
  }
}

function readNum(key: string): number {
  const n = Number(readStr(key))
  return Number.isFinite(n) ? n : 0
}

export const useUserStore = defineStore('user', {
  state: () => ({
    token: readStr(STORAGE_TOKEN),
    userId: readNum(STORAGE_USER_ID),
    openid: readStr(STORAGE_OPENID),
    userInfo: null as AppUserDto | null,
    profileCompleted: readNum(STORAGE_PROFILE_COMPLETED) === 1,
  }),
  getters: {
    isLogin: (s) => Boolean(s.token && s.userId > 0),
  },
  actions: {
    persistSession() {
      if (this.token) uni.setStorageSync(STORAGE_TOKEN, this.token)
      if (this.userId) uni.setStorageSync(STORAGE_USER_ID, this.userId)
      if (this.openid) uni.setStorageSync(STORAGE_OPENID, this.openid)
      uni.setStorageSync(STORAGE_PROFILE_COMPLETED, this.profileCompleted ? 1 : 0)
    },

    applyLoginPayload(data: WxLoginResponse) {
      this.token = data.token
      this.userId = data.userId
      this.openid = data.openid
      this.userInfo = data.userInfo
      this.profileCompleted = Boolean(data.profileCompleted)
      this.persistSession()
    },

    async loginByWxCode(code: string) {
      const data = await wxLoginByCode(code)
      this.applyLoginPayload(data)
    },

    patchFromUserDto(u: AppUserDto) {
      this.userId = u.id
      this.profileCompleted = Boolean(u.profileCompleted)
      this.userInfo = u
      uni.setStorageSync(STORAGE_USER_ID, u.id)
      uni.setStorageSync(STORAGE_PROFILE_COMPLETED, this.profileCompleted ? 1 : 0)
    },

    async fetchUserProfile() {
      if (!this.token) return null
      const u = await getUserProfile(this.token)
      this.patchFromUserDto(u)
      return u
    },

    async updateUserProfile(payload: UpdateProfilePayload) {
      if (!this.token) throw new Error('请先登录')
      const u = await updateUserProfile(this.token, payload)
      this.patchFromUserDto(u)
      return u
    },

    async bindPhone(phoneCode: string) {
      if (!this.token) throw new Error('请先登录')
      await bindPhoneByCode(this.token, phoneCode)
      return this.fetchUserProfile()
    },

    logout() {
      this.token = ''
      this.userId = 0
      this.openid = ''
      this.userInfo = null
      this.profileCompleted = false
      try {
        uni.removeStorageSync(STORAGE_TOKEN)
        uni.removeStorageSync(STORAGE_USER_ID)
        uni.removeStorageSync(STORAGE_OPENID)
        uni.removeStorageSync(STORAGE_PROFILE_COMPLETED)
      } catch {
        /* */
      }
    },
  },
})
