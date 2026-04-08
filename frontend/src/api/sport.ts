import { apiPath } from '@/config/api'
import { httpGet, httpPostAuth } from '@/utils/http'
import { toQueryString } from '@/utils/queryString'

export interface SportLibraryJson {
  id: number
  name?: string
  icon?: string
  caloriesPerMin?: number | string
  category?: string
}

export interface CreateSportRecordBody {
  sportName: string
  durationMin: number
  calories: number
  icon?: string
  recordedAt: string
}

export function searchSportLibrary(q?: string, limit = 80): Promise<SportLibraryJson[]> {
  const params: Record<string, string | undefined> = { limit: String(limit) }
  if (q != null && q.trim() !== '') params.q = q.trim()
  return httpGet<SportLibraryJson[]>(apiPath(`sport-library/search?${toQueryString(params)}`))
}

export function createSportRecord(
  userId: number,
  token: string,
  body: CreateSportRecordBody
): Promise<unknown> {
  return httpPostAuth(apiPath(`users/${userId}/sport-records`), body as Record<string, unknown>, token)
}
