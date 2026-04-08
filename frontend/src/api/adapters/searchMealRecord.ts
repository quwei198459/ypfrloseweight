import type { CreateMealRecordBody } from '@/api/meal'
import type { SearchFoodItem } from '@/types/searchFood'
import { formatRecordedAtNow } from '@/utils/recordedAt'

/**
 * 热量查询页：将搜索结果 + 弹层克数转为写库 body（与 food-search 的 createMealRecord 字段对齐）。
 * 热量：per100 用 calorie×g/100；按份用 calorie×g/servingWeightG。
 * 宏量：按库表常见「每100g」营养字段，用 g/100 缩放。
 */
export function buildMealRecordFromSearchSelection(
  food: SearchFoodItem,
  quantityInput: string,
  mealType = 'snack'
): CreateMealRecordBody | null {
  const raw = String(quantityInput ?? '').trim()
  const g = Math.floor(Number(raw))
  if (!food?.name || !Number.isFinite(g) || g <= 0) return null

  const idNum = Number(food.id)
  const foodLibraryId = Number.isFinite(idNum) && idNum > 0 ? idNum : null

  let calories: number
  if (food.calorieIsPer100g) {
    calories = Math.max(1, Math.round((food.calorie * g) / 100))
  } else {
    const denom = food.servingWeightG > 0 ? food.servingWeightG : 100
    calories = Math.max(1, Math.round((food.calorie * g) / denom))
  }

  const macroScale = g / 100
  const proteinG =
    food.proteinG != null ? Math.round(food.proteinG * macroScale * 10) / 10 : 0
  const fatG = food.fatG != null ? Math.round(food.fatG * macroScale * 10) / 10 : 0
  const carbsG =
    food.carbsG != null ? Math.round(food.carbsG * macroScale * 10) / 10 : 0

  return {
    mealType,
    foodName: food.name,
    calories,
    amountValue: g,
    amountUnit: 'g',
    recordedAt: formatRecordedAtNow(),
    foodLibraryId,
    proteinG,
    fatG,
    carbsG,
  }
}
