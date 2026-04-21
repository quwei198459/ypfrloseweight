import type { BatchMealItemBody } from '@/api/meal'
import type { SearchFoodItem } from '@/types/searchFood'

/**
 * 热量查询页：与 food-search 一致，将弹层数量转为 batch 单条（foodId + amountValue + amountUnit）。
 * amountUnit：克为 `g`；按份为「份」（每百克路径）或 `portionUnitLabel`。
 */
export function buildBatchItemFromSearchSelection(
  food: SearchFoodItem,
  quantityInput: string,
  inputMode: 'gram' | 'portion'
): BatchMealItemBody | null {
  const raw = String(quantityInput ?? '').trim()
  const amount = Number(raw)
  if (!food?.name || !Number.isFinite(amount) || amount <= 0) return null

  const idNum = Number(food.id)
  if (!Number.isFinite(idNum) || idNum <= 0) return null

  const amountUnit =
    inputMode === 'gram'
      ? 'g'
      : food.calorieIsPer100g
        ? '份'
        : food.portionUnitLabel || '份'

  return {
    foodId: idNum,
    amountValue: amount,
    amountUnit,
  }
}
