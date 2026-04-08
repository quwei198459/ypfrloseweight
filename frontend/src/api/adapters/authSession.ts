import type { WxLoginResponse } from '@/api/types'
import { mapAppUserDto } from '@/api/adapters/userProfile'

export function mapWxLoginResponse(raw: WxLoginResponse): WxLoginResponse {
  const userId = Number(raw.userId)
  return {
    ...raw,
    userId: Number.isFinite(userId) ? userId : 0,
    profileCompleted: Boolean(raw.profileCompleted),
    userInfo: raw.userInfo ? mapAppUserDto(raw.userInfo) : raw.userInfo,
  }
}
