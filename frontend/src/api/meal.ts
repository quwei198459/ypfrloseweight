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
