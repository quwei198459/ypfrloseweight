/** 与后端 ApiResponse 中 data 字段一致 */
export interface AppUserDto {
  id: number
  nickname: string | null
  avatarUrl: string | null
  gender: number | null
  age: number | null
  heightCm: number | null
  currentWeightKg: number | null
  targetWeightKg: number | null
  initialWeightKg: number | null
  targetDate: string | null
  bmr: number | null
  tdee: number | null
  dailyCalorieGoal: number | null
  /** 活动系数档位 1-5，缺省按 2 */
  activityLevel?: number | null
  /** 已绑定手机号（完整号码，前端展示建议脱敏） */
  phone: string | null
  /** 资料是否已按后端规则完善 */
  profileCompleted?: boolean | null
}

/**
 * POST /api/v1/auth/wx-login 返回（产品文档路径为 /api/user/wx-login，以实际后端为准）
 */
export interface WxLoginResponse {
  userId: number
  token: string
  openid: string
  profileCompleted: boolean
  userInfo: AppUserDto
}

/** POST /api/v1/user/profile/update 请求体 */
export interface UpdateProfilePayload {
  nickname?: string
  avatarBase64?: string
  gender?: number
  age?: number
  heightCm?: number
  currentWeightKg?: number
  targetWeightKg?: number
  initialWeightKg?: number
  /** yyyy-MM-dd */
  targetDate?: string
  /** 1-5，与后端活动系数档位一致 */
  activityLevel?: number
}

export interface DashboardDto {
  intakeCalories: number
  sportCalories: number
  dailyBudget: number
  remainingCalories: number
}

/**
 * GET /api/v1/users/{id}/week-stats?startDate=yyyy-MM-dd&endDate=yyyy-MM-dd
 * 区间为闭区间 [startDate, endDate]，近 7 日场景下为「今天往前 6 天」～「今天」。
 */
export interface WeekStatsCardDto {
  title: string
  unitLabel: string
  totalValue: number
  totalSuffix: string
  values: number[]
  yAxisLabels: number[]
  showGuideLine?: boolean
  guideValue?: number
  guideLabel?: string
  barColor?: string
  guideColor?: string
  mode?: 'deficit' | 'positive' | 'empty'
}

export interface WeekStatsDto {
  cards: WeekStatsCardDto[]
}

export interface DailyMacroDto {
  proteinG: number
  fatG: number
  carbsG: number
  /** 目标克数，由 daily-records 与 user_budget_config 汇总；缺省由前端兜底 */
  proteinTargetG?: number
  fatTargetG?: number
  carbTargetG?: number
}

export interface DailyRecordItemDto {
  kind: 'meal' | 'sport'
  id: number
  recordedAt: string | null
  title: string
  subtitle: string
  calories: number | null
}

export interface DailyRecordDto {
  date: string
  intakeCalories: number
  sportCalories: number
  macros: DailyMacroDto
  timeline: DailyRecordItemDto[]
}

/** GET /api/v1/users/{id}/weight-records 单条 */
export interface WeightRecordRow {
  id?: number
  recordDate: string
  weightKg: number
}

