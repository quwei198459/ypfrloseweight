export interface ApiResponse<T> {
  code: number
  message: string
  data: T
}

export interface AdminLoginPayload {
  username: string
  password: string
}

export interface AdminLoginResult {
  token: string
  username: string
  expireSeconds: number
}

/** 管理后台首页统计 */
export interface AdminDashboardStats {
  userTotal: number
  foodTotal: number
  todayMealRecordTotal: number
}

export interface AdminPagedResult<T> {
  total: number
  page: number
  pageSize: number
  list: T[]
}

export interface AdminUserItem {
  id: number
  nickname: string
  phone: string
  status: number
  gender: number | null
  age: number | null
  heightCm: number | null
  currentWeightKg: number | null
  targetWeightKg: number | null
  createdAt: string
}

export interface FoodCategoryItem {
  id?: number
  name: string
  code: string
  parentId?: number
  type?: string
  sortNo?: number
  status: number
}

export interface FoodItem {
  id?: number
  categoryId: number
  name: string
  image?: string
  giLevel?: string
  caloriesPer100g?: number
  caloriesPerUnit?: number
  unitName?: string
  standardWeightG?: number
  ediblePortionRate?: number
  proteinPer100g?: number
  fatPer100g?: number
  carbPer100g?: number
  keywords?: string
  status: number
}

export interface SportItem {
  id?: number
  name: string
  icon?: string
  caloriesPer60min: number
  category?: string
  sortNo?: number
  status: number
}
