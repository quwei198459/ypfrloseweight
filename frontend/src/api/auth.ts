import { mapWxLoginResponse } from '@/api/adapters/authSession'
import type { WxLoginResponse } from '@/api/types'
import { apiPath } from '@/config/api'
import { httpPost } from '@/utils/http'

/** 仅传 code：openid 绑定 + JWT，资料在个人信息页维护 */
export function wxLoginByCode(code: string): Promise<WxLoginResponse> {
  return httpPost<WxLoginResponse>(apiPath('auth/wx-login'), { code }).then(mapWxLoginResponse)
}
