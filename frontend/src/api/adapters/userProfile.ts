import type { AppUserDto } from '@/api/types'

function num(v: unknown): number | null {
  if (v == null) return null
  const n = Number(v)
  return Number.isFinite(n) ? n : null
}

/**
 * 统一用户 DTO（兼容 Long/字符串数字等），供登录与 profile 接口共用。
 */
export function mapAppUserDto(raw: AppUserDto): AppUserDto {
  return {
    ...raw,
    id: num(raw.id) ?? 0,
    gender: raw.gender != null ? num(raw.gender) : null,
    age: raw.age != null ? num(raw.age) : null,
    heightCm: raw.heightCm != null ? num(raw.heightCm) : null,
    currentWeightKg: raw.currentWeightKg != null ? num(raw.currentWeightKg) : null,
    targetWeightKg: raw.targetWeightKg != null ? num(raw.targetWeightKg) : null,
    initialWeightKg: raw.initialWeightKg != null ? num(raw.initialWeightKg) : null,
    bmr: raw.bmr != null ? num(raw.bmr) : null,
    tdee: raw.tdee != null ? num(raw.tdee) : null,
    dailyCalorieGoal: raw.dailyCalorieGoal != null ? num(raw.dailyCalorieGoal) : null,
    activityLevel: raw.activityLevel != null ? num(raw.activityLevel) : null,
    profileCompleted: (() => {
      const v = (raw as { profileCompleted?: unknown }).profileCompleted
      return v === true || v === 1 || v === '1'
    })(),
    bmiInterpretation: (() => {
      const v = (raw as { bmiInterpretation?: unknown }).bmiInterpretation
      if (v == null) return null
      const s = String(v).trim()
      return s === '' ? null : s
    })(),
    mealRecordCount: num((raw as { mealRecordCount?: unknown }).mealRecordCount),
    healthyDietDays: num((raw as { healthyDietDays?: unknown }).healthyDietDays),
    joinedDays: num((raw as { joinedDays?: unknown }).joinedDays),
    weightRecordedDaysAgo: num((raw as { weightRecordedDaysAgo?: unknown }).weightRecordedDaysAgo),
  }
}
