import type { MealTypeKey, PhotographMockResult } from '@/types/photograph'

/** 餐别展示文案 */
export const MEAL_TYPE_LABEL: Record<MealTypeKey, string> = {
  breakfast: '早餐',
  lunch: '午餐',
  dinner: '晚餐',
  snack: '加餐',
}

export const MEAL_OPTIONS: { key: MealTypeKey; label: string }[] = [
  { key: 'breakfast', label: '早餐' },
  { key: 'lunch', label: '午餐' },
  { key: 'dinner', label: '晚餐' },
  { key: 'snack', label: '加餐' },
]

export function createDefaultPhotographMock(): PhotographMockResult {
  return {
    foods: [
      {
        lineId: '1',
        foodName: '全麦面包',
        calories: 45,
        giLabel: '低 GI',
      },
    ],
    recommendedEatRatio: 1,
    intakeCaloriesToday: 72,
    dailyBudgetCalories: 638,
    badgeProgressPercent: 11,
  }
}
