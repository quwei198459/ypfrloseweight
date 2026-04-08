/**
 * 当前用户资料接口。产品文档中的 /api/user/* 对应后端 /api/v1/user/*。
 */
import { mapAppUserDto } from '@/api/adapters/userProfile'
import type { AppUserDto, UpdateProfilePayload } from '@/api/types'
import { apiPath } from '@/config/api'
import { httpGetAuth, httpPostAuth } from '@/utils/http'

export function getUserProfile(token: string): Promise<AppUserDto> {
  return httpGetAuth<AppUserDto>(apiPath('user/profile'), token).then(mapAppUserDto)
}

export function updateUserProfile(
  token: string,
  body: UpdateProfilePayload
): Promise<AppUserDto> {
  return httpPostAuth<AppUserDto>(
    apiPath('user/profile/update'),
    body as Record<string, unknown>,
    token
  ).then(mapAppUserDto)
}

export function bindPhoneByCode(token: string, code: string): Promise<Record<string, string>> {
  return httpPostAuth<Record<string, string>>(apiPath('user/bind-phone'), { code }, token)
}
