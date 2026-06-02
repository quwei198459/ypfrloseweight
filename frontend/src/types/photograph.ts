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
  /** 兼容字段：初始热量，优先使用 caloriesPer100 与 quantity 计算展示 */
  calories: number
  /** 每 100g/ml 热量，聚美 calory 字段口径 */
  caloriesPer100?: number
  /** 用户确认数量，默认 100 */
  quantity: number
  /** 当前识图页统一显示 g/ml */
  quantityUnit: string
  /** 聚美类型：1=食物，2=营养成分 */
  type?: number
  giLabel?: string
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
