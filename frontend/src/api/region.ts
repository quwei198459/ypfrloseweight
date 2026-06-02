import { apiPath } from '@/config/api'
import { httpGet } from '@/utils/http'

export interface RegionAreaNode {
  code: string
  name: string
  level: number
  children?: RegionAreaNode[]
}

export function getRegionTree(): Promise<RegionAreaNode[]> {
  return httpGet<RegionAreaNode[]>(apiPath('regions/tree'))
}
