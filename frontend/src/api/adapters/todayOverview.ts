import type { DashboardDto } from '@/api/types'

/** 后端当前与 DashboardDto 一致；PRD 换路径或换字段时在此收敛映射 */
export function mapToDashboardDto(raw: DashboardDto): DashboardDto {
  return raw
}
