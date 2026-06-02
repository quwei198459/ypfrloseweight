import { apiPath, resolveUserId, STORAGE_TOKEN } from '@/config/api'
import { httpGetAuth, httpPost, httpPostAuth } from '@/utils/http'
import { toQueryString } from '@/utils/queryString'

export interface FoodRecognizeResponse {
  httpStatus: number
  body: string
}

export interface RecognizeFoodPayload {
  imageBase64?: string
  imageUrl?: string
  userId?: number
}

export interface PhotoRecognitionAccessVo {
  allowed: boolean
  phoneBound: boolean
  reason: 'allowed' | 'phone_required' | 'not_member' | 'quota_exhausted' | string
  message: string
  servicePhone?: string | null
  serviceWechat?: string | null
  serviceQrImageUrl?: string | null
  serviceQrImagePath?: string | null
  serviceQrImageName?: string | null
  totalQuota?: number | null
  usedCount?: number | null
  remainingCount?: number | null
}

/** 与后端 MealPhotoFoodItemVo 对齐 */
export interface MealPhotoFoodItemVo {
  lineId: string
  foodName: string
  calories: number
  type?: number
  caloriesPer100?: number
  quantity?: number
  quantityUnit?: string
  giLabel?: string
  foodId?: number
  weightG?: number
}

/** 与后端 MealPhotoRecognizeResultVo 对齐 */
export interface MealPhotoRecognizeResultVo {
  photoJobId: number
  recognizeStatus: string
  recognizePhase?: string | null
  imageUrl?: string | null
  previewUrl?: string | null
  recommendedMealType?: string | null
  foods?: MealPhotoFoodItemVo[]
  recommendedEatRatio?: number | null
  intakeCaloriesToday?: number | null
  dailyBudgetCalories?: number | null
  badgeProgressPercent?: number | null
  confirmStatus?: string | null
  totalRecognizedCalories?: number | null
  errorCode?: string | null
  errorMessage?: string | null
}

export interface MealPhotoSubmitPayload {
  userId?: number
  source?: 'camera' | 'album' | string
  mealType?: string
  recordDate?: string
  imageBase64?: string
  imageUrl?: string
}

export interface MealPhotoConfirmItemPayload {
  lineId: string
  foodId?: number
  confirmedFoodName?: string
  confirmedCalories: number
  confirmedEatRatio?: number
  confirmedQuantity?: number
  confirmedQuantityUnit?: string
  caloriesPer100?: number
}

export interface MealPhotoConfirmPayload {
  userId?: number
  photoJobId: number
  confirmedMealType: string
  recordDate?: string
  items: MealPhotoConfirmItemPayload[]
}

export interface MealPhotoConfirmResponseVo {
  mealRecordId?: number | null
  dietRecordIds?: number[]
  confirmStatus?: string | null
  confirmedAt?: string | null
  intakeCaloriesToday?: number | null
  dailyBudgetCalories?: number | null
}

/** 旧版直连阿里云透传，保留兼容 */
export function recognizeFood(payload: RecognizeFoodPayload): Promise<FoodRecognizeResponse> {
  const uid = payload.userId ?? resolveUserId()
  const body: Record<string, unknown> = { userId: uid }
  if (payload.imageBase64) body.imageBase64 = payload.imageBase64
  if (payload.imageUrl) body.imageUrl = payload.imageUrl
  return httpPost<FoodRecognizeResponse>(apiPath('food/recognize'), body)
}

export function checkMealPhotoAccess(): Promise<PhotoRecognitionAccessVo> {
  const token = (uni.getStorageSync(STORAGE_TOKEN) as string | undefined)?.trim()
  if (!token) {
    return Promise.reject(new Error('请先登录'))
  }
  return httpGetAuth<PhotoRecognitionAccessVo>(apiPath('recognize/meal-photo/access'), token)
}

/** 餐前拍一拍：提交识图（落库 + 调用识图服务） */
export function submitMealPhoto(payload: MealPhotoSubmitPayload): Promise<MealPhotoRecognizeResultVo> {
  const token = (uni.getStorageSync(STORAGE_TOKEN) as string | undefined)?.trim()
  if (!token) {
    return Promise.reject(new Error('请先登录'))
  }
  const uid = payload.userId ?? resolveUserId()
  const body: Record<string, unknown> = { userId: uid }
  if (payload.source) body.source = payload.source
  if (payload.mealType) body.mealType = payload.mealType
  if (payload.recordDate) body.recordDate = payload.recordDate
  if (payload.imageBase64) body.imageBase64 = payload.imageBase64
  if (payload.imageUrl) body.imageUrl = payload.imageUrl
  return httpPostAuth<MealPhotoRecognizeResultVo>(apiPath('recognize/meal-photo'), body, token)
}

export function getMealPhotoResult(userId: number, photoJobId: number): Promise<MealPhotoRecognizeResultVo> {
  const token = (uni.getStorageSync(STORAGE_TOKEN) as string | undefined)?.trim()
  if (!token) {
    return Promise.reject(new Error('请先登录'))
  }
  const tail = toQueryString({ userId: String(userId), photoJobId: String(photoJobId) })
  return httpGetAuth<MealPhotoRecognizeResultVo>(
    `${apiPath('recognize/meal-photo/result')}?${tail}`,
    token
  )
}

export function confirmMealPhoto(payload: MealPhotoConfirmPayload): Promise<MealPhotoConfirmResponseVo> {
  const token = (uni.getStorageSync(STORAGE_TOKEN) as string | undefined)?.trim()
  if (!token) {
    return Promise.reject(new Error('请先登录'))
  }
  const uid = payload.userId ?? resolveUserId()
  const body: Record<string, unknown> = {
    userId: uid,
    photoJobId: payload.photoJobId,
    confirmedMealType: payload.confirmedMealType,
    items: payload.items.map((it) => ({
      lineId: it.lineId,
      foodId: it.foodId,
      confirmedFoodName: it.confirmedFoodName,
      confirmedCalories: it.confirmedCalories,
      confirmedEatRatio: it.confirmedEatRatio,
      confirmedQuantity: it.confirmedQuantity,
      confirmedQuantityUnit: it.confirmedQuantityUnit,
      caloriesPer100: it.caloriesPer100,
    })),
  }
  if (payload.recordDate) body.recordDate = payload.recordDate
  return httpPostAuth<MealPhotoConfirmResponseVo>(apiPath('recognize/meal-photo/confirm'), body, token)
}

export function isVendorRecognizeSuccess(res: FoodRecognizeResponse): boolean {
  const s = Number(res.httpStatus)
  return s >= 200 && s < 300
}
