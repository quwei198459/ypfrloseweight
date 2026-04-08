/** 后端根地址（微信小程序真机请改为电脑局域网 IP + 端口，并勾选开发环境不校验域名） */
export const API_BASE_URL = (
  import.meta.env.VITE_API_BASE_URL as string | undefined
)?.replace(/\/$/, '') || 'http://127.0.0.1:8080'

/**
 * REST 路径前缀。与后端 Controller 一致；若迁移 PRD 仅 `/api` 时改环境变量或此处默认值即可。
 * 例：`.env` 中 `VITE_API_PATH_PREFIX=/api`
 */
export const API_PATH_PREFIX = (
  import.meta.env.VITE_API_PATH_PREFIX as string | undefined
)?.replace(/\/$/, '') || '/api/v1'

/** 拼接为 `${API_BASE_URL}${API_PATH_PREFIX}/...`，segment 可带或不带前导 `/` */
export function apiPath(segment: string): string {
  const s = segment.startsWith('/') ? segment.slice(1) : segment
  return `${API_PATH_PREFIX}/${s}`
}

/** 未登录联调时的默认用户 ID（微信登录成功后会写入 lw_user_id） */
export const API_USER_ID = Number(import.meta.env.VITE_DEV_USER_ID || 1)

export const STORAGE_USER_ID = 'lw_user_id'
export const STORAGE_TOKEN = 'lw_token'
/** 微信 openid，登录接口返回后写入 */
export const STORAGE_OPENID = 'lw_openid'
/** 1/0，是否与后端 profile_completed 同步 */
export const STORAGE_PROFILE_COMPLETED = 'lw_profile_completed'

/** 优先使用微信登录后保存的用户 ID */
export function resolveUserId(): number {
  try {
    const v = uni.getStorageSync(STORAGE_USER_ID)
    if (v !== '' && v != null && !Number.isNaN(Number(v))) {
      return Number(v)
    }
  } catch {
    /* 非小程序环境等 */
  }
  return API_USER_ID
}
