import { apiPath } from '@/config/api'
import { httpDeleteAuth, httpPostAuth } from '@/utils/http'

export interface CreateMealRecordBody {
  mealType: string
  foodName: string
  calories: number
  amountValue: number
  amountUnit: string
  recordedAt: string
  foodLibraryId?: number | null
  proteinG?: number
  fatG?: number
  carbsG?: number
}

export interface MealEntryVo {
  id: number
  userId: number
  mealType: string
  foodName: string
  calories: number
  amountValue?: number
  amountUnit?: string
  recordedAt?: string
  foodLibraryId?: number
  proteinG?: number
  fatG?: number
  carbsG?: number
}

export function createMealRecord(
  userId: number,
  token: string,
  body: CreateMealRecordBody
): Promise<MealEntryVo> {
  return httpPostAuth<MealEntryVo>(
    apiPath(`users/${userId}/meal-records`),
    body as Record<string, unknown>,
    token
  )
}

export function deleteMealRecord(userId: number, token: string, id: number): Promise<void> {
  return httpDeleteAuth<void>(apiPath(`users/${userId}/meal-records/${id}`), token)
}

/** POST .../meal-records/batch：同一日餐次追加多条明细 */
export interface BatchMealItemBody {
  foodId: number
  amountValue: number
  amountUnit: string
  /** 可选；缺省使用批次 recordedAt */
  recordedAt?: string
}

export interface CreateMealRecordsBatchBody {
  recordDate: string
  mealType: string
  /** 可选；与各条 recordedAt 共同约束 record_time */
  recordedAt?: string
  items: BatchMealItemBody[]
}

export interface CreateMealRecordsBatchResult {
  mealRecordId: number
  entries: MealEntryVo[]
}

export function createMealRecordsBatch(
  userId: number,
  token: string,
  body: CreateMealRecordsBatchBody
): Promise<CreateMealRecordsBatchResult> {
  return httpPostAuth<CreateMealRecordsBatchResult>(
    apiPath(`users/${userId}/meal-records/batch`),
    body as Record<string, unknown>,
    token
  )
}
