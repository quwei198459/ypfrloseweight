/** 餐前拍一拍页面主流程（对齐设计稿与补充 PRD） */
export type PhotographPhase =
  | 'idle'
  | 'uploading'
  | 'recognizing_type'
  | 'recognizing_weight'
  | 'success'
  | 'mealtype_dropdown_open'
  | 'editing_calorie'
  | 'adjusting_ratio'
  | 'failed'
  | 'saved'

export type MealTypeKey = 'breakfast' | 'lunch' | 'dinner' | 'snack'

export interface PhotographMockFood {
  lineId: string
  foodName: string
  calories: number
  giLabel: string
  /** 后端食物库 id，确认写入时透传 */
  foodId?: number
}

export interface PhotographMockResult {
  foods: PhotographMockFood[]
  recommendedEatRatio: number
  intakeCaloriesToday: number
  dailyBudgetCalories: number
  badgeProgressPercent: number
}
