import { fetchCurrentUser } from '@/api/loseweight'
import { buildPlanPageDataFromProfile, type PlanPageData } from '@/api/adapters/planPreview'

/** 计划页暂无独立后端接口：由用户资料聚合生成展示数据 */
export async function fetchPlanPageData(): Promise<PlanPageData> {
  const user = await fetchCurrentUser()
  return buildPlanPageDataFromProfile(user)
}

export type { PlanPageData }
