import { apiPath } from '@/config/api'
import { httpGet, httpGetAuth, httpPostAuth } from '@/utils/http'
import { toQueryString } from '@/utils/queryString'

/** 与后端 Food 序列化字段对齐（含 @JsonProperty 别名） */
/** GET /api/v1/food-categories 单项 */
export interface FoodCategoryItemJson {
  code: string
  name: string
  sortNo: number
}

export function listFoodCategories(token?: string): Promise<FoodCategoryItemJson[]> {
  const path = apiPath('food-categories')
  const t = token?.trim()
  return t
    ? httpGetAuth<FoodCategoryItemJson[]>(path, t)
    : httpGet<FoodCategoryItemJson[]>(path)
}

export interface FoodLibraryJson {
  id: number
  name?: string
  image?: string
  caloriesPer100?: number | string
  caloriesPerUnit?: number | string
  unitLabel?: string
  standardWeightG?: number | string
  protein?: number | string
  fat?: number | string
  carbs?: number | string
  giLevel?: string
  category?: string
}

export function searchFoodLibrary(
  q?: string,
  limit = 50,
  token?: string,
  forUserId?: number,
  categoryCode?: string
): Promise<FoodLibraryJson[]> {
  const params: Record<string, string | undefined> = { limit: String(limit) }
  if (q != null && q.trim() !== '') params.q = q.trim()
  if (forUserId != null && Number.isFinite(forUserId)) params.forUserId = String(forUserId)
  if (categoryCode != null && String(categoryCode).trim() !== '') {
    params.categoryCode = String(categoryCode).trim()
  }
  const tail = toQueryString(params)
  const path = apiPath(`food-library/search?${tail}`)
  const t = token?.trim()
  return t
    ? httpGetAuth<FoodLibraryJson[]>(path, t)
    : httpGet<FoodLibraryJson[]>(path)
}

export interface CreateCustomFoodBody {
  name: string
  weightG: number
  calories: number
}

export function createCustomFood(
  userId: number,
  token: string,
  body: CreateCustomFoodBody
): Promise<FoodLibraryJson> {
  return httpPostAuth<FoodLibraryJson>(
    apiPath(`users/${userId}/custom-foods`),
    {
      name: body.name,
      weightG: body.weightG,
      calories: body.calories,
    },
    token
  )
}
