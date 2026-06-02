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

export interface PhotoRecognitionMemberPhone {
  id?: number
  phone: string
  remark?: string | null
  status: number
  totalQuota?: number
  usedCount?: number
  quotaUpdatedAt?: string
  createdAt?: string
  updatedAt?: string
}

export interface PhotoRecognitionQuotaLogItem {
  id: number
  changeType: 'grant' | 'reduce' | 'consume' | string
  changeCount: number
  beforeTotalQuota: number
  beforeUsedCount: number
  afterTotalQuota: number
  afterUsedCount: number
  photoJobId?: number | null
  remark?: string | null
  operatorType?: string | null
  operatorName?: string | null
  createdAt: string
}

export interface PhotoRecognitionQuotaSummary {
  grantCount: number
  reduceCount: number
  usedCount: number
  currentBalance: number
}

export interface PhotoRecognitionServiceConfig {
  servicePhone: string
  serviceWechat: string
  serviceQrImageUrl?: string | null
  serviceQrImagePath?: string | null
  serviceQrImageName?: string | null
  remark?: string | null
  status: number
}

export interface SkinDetectionWhitelist {
  id?: number
  phone: string
  remark?: string | null
  status: number
  totalTimes?: number
  usedTimes?: number
  quotaUpdatedAt?: string
  createdAt?: string
  updatedAt?: string
}

export interface SkinDetectionQuotaLogItem {
  id: number
  changeType: 'grant' | 'reduce' | 'consume' | string
  changeCount: number
  beforeTotalTimes: number
  beforeUsedTimes: number
  afterTotalTimes: number
  afterUsedTimes: number
  userId?: number | null
  recordId?: number | null
  remark?: string | null
  operatorType?: string | null
  operatorName?: string | null
  createdAt: string
}

export interface SkinDetectionQuotaSummary {
  grantCount: number
  reduceCount: number
  usedCount: number
  currentBalance: number
}

export interface SkinDetectionItemConfig {
  id: number
  itemCode: string
  yimeiField: string
  detectType: number
  itemName: string
  displayName: string
  sortOrder: number
  enabled: number
  scaleType: string
  scoreDirection: string
  promptKey: string
  remark?: string | null
  createdAt?: string
  updatedAt?: string
}

export interface SkinDetectionAiPromptTemplate {
  id: number
  promptKey: string
  promptType: string
  itemCode?: string | null
  promptName: string
  templateContent: string
  outputSchema?: string | null
  model: string
  temperature: number
  status: number
  version: number
  remark?: string | null
  createdAt?: string
  updatedAt?: string
}

export interface SkinDetectionRecordItem {
  itemCode: string
  itemName: string
  score: number | null
  level: string | null
  resultText: string | null
  resultImage: string | null
  metricsJson: string | null
  sortOrder: number | null
  scaleType?: string | null
  aiConclusion?: string | null
  aiReason?: string | null
  aiCareAdvice?: string | null
  aiRawJson?: string | null
  aiStatus?: string | null
  aiError?: string | null
}

export interface SkinDetectionRecord {
  id: number
  userId: number
  phone: string | null
  userName: string | null
  gender: number | null
  birthday: string | null
  age: number | null
  residence: string | null
  imageUrl: string | null
  detectTypes: number | null
  overallScore: number | null
  aiSummary?: string | null
  status: string
  failReason: string | null
  deepseekStatus: string | null
  deepseekError?: string | null
  createdAt: string
  updatedAt?: string
}

export interface SkinDetectionRecordDetail {
  recordId: number
  userId: number
  phone: string | null
  userName: string | null
  gender: number | null
  birthday: string | null
  age: number | null
  residence: string | null
  imageUrl: string | null
  detectTypes: number | null
  overallScore: number | null
  aiSummary: string | null
  status: string
  failReason: string | null
  deepseekStatus: string | null
  deepseekError: string | null
  createdAt: string
  items: SkinDetectionRecordItem[]
}

