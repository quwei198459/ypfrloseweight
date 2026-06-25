import { apiPath } from '@/config/api'
import { httpGet } from '@/utils/http'

/** 首页入口可见性（后台「系统配置-首页入口显示」控制） */
export interface HomeEntryConfig {
  skinDetectionEntryVisible: boolean
  tcmDetectionEntryVisible: boolean
}

/** 公开接口，无需登录；失败时调用方应回退为「显示」，避免误隐藏入口 */
export function fetchHomeEntryConfig(): Promise<HomeEntryConfig> {
  return httpGet<HomeEntryConfig>(apiPath('app-config/home-entries'))
}
