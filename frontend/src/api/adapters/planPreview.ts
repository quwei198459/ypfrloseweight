import type { AppUserDto } from '@/api/types'

export interface PlanPageData {
  duration: number
  startWeight: number
  targetWeight: number
  weeklyLoss: number
  bmi: number
  bmiLevel: string
  bmiDescription: string
  planWeeks: number
  totalLoss: number
  socialProofPercent: number
  progressSectionTitle: string
  phaseList: { phaseName: string }[]
  weightMilestones: { value: number; color: string; arrowColor?: string }[]
  /** 四阶段曲线图下方左侧日期（如 4月19日） */
  timelineStartLabel: string
  /** 四阶段曲线图下方右侧日期 */
  timelineEndLabel: string
  calorieLabel: string
  exerciseLabel: string
  dietPatternLabel: string
  dietRecommendLabel: string
  calorieValue: string
  exerciseValue: string
  dietPatternValue: string
  dietRecommendValue: string
  userCaseAchievementPrefix: string
  userCaseLoss: string
  userCaseDate: string
  bottomSlogan: string
  primaryButtonText: string
  showVipBadge: boolean
}

/** 接口失败或与后端无关字段时的展示兜底 */
export const PLAN_PAGE_FALLBACK: PlanPageData = {
  duration: 8,
  startWeight: 162,
  targetWeight: 154,
  weeklyLoss: 1,
  bmi: 26.4,
  bmiLevel: '超重',
  bmiDescription:
    '您的体重超重，处于肥胖前期。建议控制总能量摄入，注重均衡，增加蔬果、谷物及优质蛋白质摄入，并保持规律运动。',
  planWeeks: 8,
  totalLoss: 8.0,
  socialProofPercent: 92,
  progressSectionTitle: '减脂是最好的逆袭',
  phaseList: [{ phaseName: '启动' }, { phaseName: '减脂' }, { phaseName: '巩固' }],
  weightMilestones: [
    { value: 170, color: '#e53935', arrowColor: '#e53935' },
    { value: 150, color: '#fb8c00', arrowColor: '#43a047' },
    { value: 120, color: '#2e7d32' },
  ],
  timelineStartLabel: '4月19日',
  timelineEndLabel: '7月12日',
  calorieLabel: '热量缺口',
  exerciseLabel: '运动',
  dietPatternLabel: '饮食节奏',
  dietRecommendLabel: '饮食推荐',
  calorieValue: '418千卡/天',
  exerciseValue: '2-3次/周',
  dietPatternValue: '8+16 轻断食',
  dietRecommendValue: '减少糖、盐、油脂',
  userCaseAchievementPrefix: '18 周减重 ',
  userCaseLoss: '12.8',
  userCaseDate: '3月7日达成',
  bottomSlogan: '改变，从这里开始！遇见更好的自己吧！',
  primaryButtonText: '开始使用专属计划',
  showVipBadge: true,
}

function formatCnMonthDayFromYmd(ymd: string | null | undefined): string | null {
  if (!ymd || !/^\d{4}-\d{2}-\d{2}$/.test(ymd.trim())) return null
  const d = new Date(ymd.trim() + 'T12:00:00')
  if (Number.isNaN(d.getTime())) return null
  return `${d.getMonth() + 1}月${d.getDate()}日`
}

function todayCnLabel(): string {
  const d = new Date()
  return `${d.getMonth() + 1}月${d.getDate()}日`
}

function daysUntil(ymd: string | null | undefined): number | null {
  if (!ymd || !/^\d{4}-\d{2}-\d{2}$/.test(ymd.trim())) return null
  const end = new Date(ymd.trim() + 'T12:00:00')
  const now = new Date()
  const start = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 12, 0, 0)
  const ms = end.getTime() - start.getTime()
  if (ms <= 0) return null
  return Math.ceil(ms / 86400000)
}

function bmiFromProfile(user: AppUserDto): number {
  const h = Number(user.heightCm)
  const w = Number(user.currentWeightKg)
  if (!Number.isFinite(h) || h <= 0 || !Number.isFinite(w) || w <= 0) return 0
  const m = h / 100
  return Math.round((w / (m * m)) * 10) / 10
}

function bmiCopy(bmi: number): { level: string; desc: string } {
  if (bmi <= 0) {
    return {
      level: '标准',
      desc: '完善身高与当前体重后，可查看更准确的 BMI 解读与饮食建议。',
    }
  }
  if (bmi < 18.5) {
    return {
      level: '偏低',
      desc: '体重偏轻时建议保证充足热量与优质蛋白，避免过度节食，可结合力量训练增肌。',
    }
  }
  if (bmi < 24) {
    return {
      level: '标准',
      desc: '体重在健康范围内，建议保持均衡饮食与规律运动，巩固当前状态。',
    }
  }
  if (bmi < 28) {
    return {
      level: '超重',
      desc: '您的体重超重，处于肥胖前期。建议控制总能量摄入，注重均衡，增加蔬果、谷物及优质蛋白质摄入，并保持规律运动。',
    }
  }
  return {
    level: '肥胖',
    desc: '建议在医生或营养师指导下制定减重计划，循序渐进降低体重并关注代谢健康。',
  }
}

const STATIC: Pick<
  PlanPageData,
  | 'socialProofPercent'
  | 'progressSectionTitle'
  | 'phaseList'
  | 'calorieLabel'
  | 'exerciseLabel'
  | 'dietPatternLabel'
  | 'dietRecommendLabel'
  | 'calorieValue'
  | 'exerciseValue'
  | 'dietPatternValue'
  | 'dietRecommendValue'
  | 'userCaseAchievementPrefix'
  | 'userCaseLoss'
  | 'userCaseDate'
  | 'bottomSlogan'
  | 'primaryButtonText'
  | 'showVipBadge'
> = {
  socialProofPercent: 92,
  progressSectionTitle: '减脂是最好的逆袭',
  phaseList: [
    { phaseName: '适应期' },
    { phaseName: '减重期' },
    { phaseName: '塑形期' },
    { phaseName: '巩固期' },
  ],
  calorieLabel: '热量缺口',
  exerciseLabel: '运动',
  dietPatternLabel: '饮食节奏',
  dietRecommendLabel: '饮食推荐',
  calorieValue: '418千卡/天',
  exerciseValue: '2-3次/周',
  dietPatternValue: '8+16 轻断食',
  dietRecommendValue: '减少糖、盐、油脂',
  userCaseAchievementPrefix: '18 周减重 ',
  userCaseLoss: '12.8',
  userCaseDate: '3月7日达成',
  bottomSlogan: '改变，从这里开始！遇见更好的自己吧！',
  primaryButtonText: '开始使用专属计划',
  showVipBadge: true,
}

/** 用资料页数据生成计划展示（无独立计划接口时的前端聚合） */
export function buildPlanPageDataFromProfile(user: AppUserDto): PlanPageData {
  const curKg = Number(user.currentWeightKg)
  const tgtKg = Number(user.targetWeightKg)
  const startJin =
    Number.isFinite(curKg) && curKg > 0 ? Math.round(curKg * 2 * 10) / 10 : 160
  let targetJin =
    Number.isFinite(tgtKg) && tgtKg > 0 ? Math.round(tgtKg * 2 * 10) / 10 : startJin - 8
  if (targetJin >= startJin) targetJin = Math.max(1, Math.round((startJin - 4) * 10) / 10)

  const totalLoss = Math.max(0.5, Math.round((startJin - targetJin) * 10) / 10)

  const days = daysUntil(user.targetDate)
  let planWeeks = 8
  if (days != null) {
    planWeeks = Math.min(24, Math.max(4, Math.ceil(days / 7)))
  }
  const duration = planWeeks
  const weeklyLoss = Math.max(0.1, Math.round((totalLoss / planWeeks) * 10) / 10)

  const bmi = bmiFromProfile(user)
  const { level, desc: fallbackDesc } = bmiCopy(bmi)
  const serverDesc =
    user.bmiInterpretation != null && String(user.bmiInterpretation).trim() !== ''
      ? String(user.bmiInterpretation).trim()
      : null
  const desc = serverDesc ?? fallbackDesc
  const bmiDisplay = bmi > 0 ? bmi : 24

  const midJin = Math.round(((startJin + targetJin) / 2) * 10) / 10
  const milestones = [
    { value: Math.round(startJin), color: '#e53935', arrowColor: '#e53935' },
    { value: midJin, color: '#fb8c00', arrowColor: '#43a047' },
    { value: Math.round(targetJin), color: '#2e7d32' },
  ]

  const endCn = formatCnMonthDayFromYmd(user.targetDate)
  const timelineStartLabel = todayCnLabel()
  const timelineEndLabel = endCn ?? `${planWeeks}周后`

  return {
    ...STATIC,
    duration,
    startWeight: startJin,
    targetWeight: targetJin,
    weeklyLoss,
    bmi: bmiDisplay,
    bmiLevel: level,
    bmiDescription: desc,
    planWeeks,
    totalLoss,
    weightMilestones: milestones,
    timelineStartLabel,
    timelineEndLabel,
  }
}
