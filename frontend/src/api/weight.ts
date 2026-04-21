import type { WeightRecordRow } from '@/api/types'
import { mapWeightRecordRows } from '@/api/adapters/weightTrend'
import { apiPath, resolveUserId, STORAGE_TOKEN } from '@/config/api'
import { httpGet, httpGetAuth, httpPost, httpPostAuth } from '@/utils/http'

export interface WeightUpsertBody {
  recordDate: string
  weightKg: number
}

export function fetchWeightRecords(limit = 90): Promise<WeightRecordRow[]> {
  const id = resolveUserId()
  const qs = `limit=${encodeURIComponent(String(limit))}`
  try {
    const token = uni.getStorageSync(STORAGE_TOKEN) as string | undefined
    if (token) {
      return httpGetAuth<unknown[]>(apiPath(`users/${id}/weight-records?${qs}`), token).then(
        mapWeightRecordRows
      )
    }
  } catch {
    /* */
  }
  return httpGet<unknown[]>(apiPath(`users/${id}/weight-records?${qs}`)).then(mapWeightRecordRows)
}

export function addWeightRecord(userId: number, body: WeightUpsertBody): Promise<unknown> {
  try {
    const token = uni.getStorageSync(STORAGE_TOKEN) as string | undefined
    if (token) {
      return httpPostAuth<unknown>(
        apiPath(`users/${userId}/weight-records`),
        body as Record<string, unknown>,
        token
      )
    }
  } catch {
    /* */
  }
  return httpPost(apiPath(`users/${userId}/weight-records`), body as Record<string, unknown>)
}
