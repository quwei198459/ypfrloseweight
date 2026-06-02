import type { AppUserDto, DailyRecordDto, DashboardDto, WeekStatsDto } from '@/api/types'
import { mapToDailyRecordDto } from '@/api/adapters/dailyRecord'
import { mapToDashboardDto } from '@/api/adapters/todayOverview'
import { mapAppUserDto } from '@/api/adapters/userProfile'
import { mapToWeekStatsDto } from '@/api/adapters/weekReport'
import { apiPath, resolveUserId, STORAGE_TOKEN } from '@/config/api'
import { httpGet, httpGetAuth } from '@/utils/http'

function requireToken(): string {
  const token = uni.getStorageSync(STORAGE_TOKEN) as string | undefined
  if (!token) throw new Error('请先登录')
  return token
}

export function fetchDashboard(date: string): Promise<DashboardDto> {
  const id = resolveUserId()
  const q = encodeURIComponent(date)
  const token = requireToken()
  return httpGetAuth<DashboardDto>(apiPath(`users/${id}/dashboard?date=${q}`), token).then(
    mapToDashboardDto
  )
}

/**
 * 近 7 日（或其它）统计，由日期范围驱动，与「自然周」无关。
 * startDate、endDate 均为 yyyy-MM-dd，闭区间。
 */
export function fetchWeekStats(startDate: string, endDate: string): Promise<WeekStatsDto> {
  const id = resolveUserId()
  const qs = `startDate=${encodeURIComponent(startDate)}&endDate=${encodeURIComponent(endDate)}`
  try {
    const token = uni.getStorageSync(STORAGE_TOKEN) as string | undefined
    if (token) {
      return httpGetAuth<WeekStatsDto>(apiPath(`users/${id}/week-stats?${qs}`), token).then(
        mapToWeekStatsDto
      )
    }
  } catch {
    /* */
  }
  return httpGet<WeekStatsDto>(apiPath(`users/${id}/week-stats?${qs}`)).then(mapToWeekStatsDto)
}

/** GET /api/v1/users/{id}/daily-records?date=yyyy-MM-dd */
export function fetchDailyRecord(date?: string): Promise<DailyRecordDto> {
  const id = resolveUserId()
  const qs = date ? `?date=${encodeURIComponent(date)}` : ''
  const token = requireToken()
  return httpGetAuth<DailyRecordDto>(apiPath(`users/${id}/daily-records${qs}`), token).then(
    mapToDailyRecordDto
  )
}

export function fetchCurrentUser(): Promise<AppUserDto> {
  try {
    const token = uni.getStorageSync(STORAGE_TOKEN) as string | undefined
    if (token) {
      return httpGetAuth<AppUserDto>(apiPath('user/profile'), token).then(mapAppUserDto)
    }
  } catch {
    /* 非小程序环境 */
  }
  const id = resolveUserId()
  return httpGet<AppUserDto>(apiPath(`users/${id}`)).then(mapAppUserDto)
}
