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

export interface TcmDetectionWhitelist {
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

export interface TcmDetectionQuotaLogItem {
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

export interface TcmDetectionQuotaSummary {
  grantCount: number
  reduceCount: number
  usedCount: number
  currentBalance: number
}

export interface TcmDetectionItemConfig {
  id: number
  itemCode: string
  vendorField: string
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

export interface TcmDetectionAiPromptTemplate {
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

/** 望诊特征项（来自脉景 API）。metricsJson 为 JSON 字符串，解析后即 TcmInspectionMetrics */
export interface TcmDetectionRecordItem {
  itemCode: string
  itemName: string
  level: string | null
  resultText: string | null
  scaleType: string | null
  metricsJson: string | null
  sortOrder: number | null
}

/** TcmDetectionRecordItem.metricsJson 解析后的结构 */
export interface TcmInspectionMetrics {
  group?: string
  featureName?: string
  situation?: string
  category?: string
}

/** reportJson 内 advices.food 的单项 */
export interface TcmReportFoodAdvice {
  title?: string
  advice?: string
}

/** reportJson 内 goods 推荐商品的单项 */
export interface TcmReportGoods {
  name?: string
  img1?: string
}

/** TcmDetectionRecordDetail.reportJson 解析后的结构 */
export interface TcmDetectionReport {
  physiqueName?: string
  physiqueAnalysis?: string
  typicalSymptom?: string
  riskWarning?: string
  syndromeName?: string
  syndromeIntroduction?: string
  advices?: {
    food?: TcmReportFoodAdvice[]
    music?: TcmReportFoodAdvice[]
    sleep?: TcmReportFoodAdvice[]
    sport?: TcmReportFoodAdvice[]
    treatment?: TcmReportFoodAdvice[]
  }
  goods?: TcmReportGoods[]
  annotatedTongueUrl?: string
}

export interface TcmDetectionRecord {
  id: number
  userId: number
  phone: string | null
  userName: string | null
  gender: number | null
  birthday: string | null
  age: number | null
  residence: string | null
  tongueImageUrl: string | null
  faceImageUrl: string | null
  constitutionPrimary: string | null
  overallScore: number | null
  aiSummary?: string | null
  status: string
  failReason: string | null
  deepseekStatus: string | null
  deepseekError?: string | null
  createdAt: string
  updatedAt?: string
}

export interface TcmDetectionRecordDetail {
  recordId: number
  userId: number
  phone: string | null
  userName: string | null
  gender: number | null
  birthday: string | null
  age: number | null
  residence: string | null
  tongueImageUrl: string | null
  faceImageUrl: string | null
  constitutionPrimary: string | null
  overallScore: number | null
  /** ★ JSON 字符串，需 JSON.parse 为 TcmDetectionReport */
  reportJson: string | null
  aiSummary: string | null
  status: string
  failReason: string | null
  deepseekStatus: string | null
  deepseekError: string | null
  createdAt: string
  items: TcmDetectionRecordItem[]
}

export interface SystemConfig {
  /** true=白名单限制开启（需在白名单内才可用）；false=关闭限制（所有用户可用） */
  photoRecognitionWhitelistEnabled: boolean
  skinDetectionWhitelistEnabled: boolean
  tcmDetectionWhitelistEnabled?: boolean
  /** true=首页入口显示；false=隐藏 */
  skinDetectionEntryVisible?: boolean
  tcmDetectionEntryVisible?: boolean
}

export interface DeepSeekFeatureStat {
  feature: string
  calls: number
  tokens: number
  costCny: number
}

export interface DeepSeekModelStat {
  billedModel: string
  calls: number
  tokens: number
  costCny: number
}

export interface DeepSeekDailyStat {
  date: string
  calls: number
  costCny: number
}

export interface DeepSeekUserStat {
  userId: number
  nickname: string | null
  phone: string | null
  calls: number
  costCny: number
}

export interface DeepSeekUsageSummary {
  from: string
  to: string
  totalCalls: number
  totalTokens: number
  totalCostCny: number
  byFeature: DeepSeekFeatureStat[]
  byBilledModel: DeepSeekModelStat[]
  daily: DeepSeekDailyStat[]
  topUsers: DeepSeekUserStat[]
}

export interface DeepSeekUsageLog {
  id: number
  feature: string
  scene: string | null
  model: string
  billedModel: string
  userId: number | null
  recordId: number | null
  promptTokens: number
  cacheHitTokens: number
  cacheMissTokens: number
  completionTokens: number
  totalTokens: number
  costCny: number
  createdAt: string
}


export interface AiCostFeature {
  feature: string
  displayName: string
  vendorCalls: number
  vendorSuccessCalls: number
  vendorCostCny: number
  deepseekCalls: number
  deepseekCostCny: number
  totalCostCny: number
}

export interface AiCostProvider {
  provider: string
  displayName: string
  calls: number
  successCalls: number
  freeCalls: number
  costCny: number
}

export interface AiCostDaily {
  date: string
  vendorCostCny: number
  deepseekCostCny: number
  totalCostCny: number
}

export interface AiCostSummary {
  from: string
  to: string
  totalCostCny: number
  vendorCostCny: number
  deepseekCostCny: number
  byFeature: AiCostFeature[]
  byProvider: AiCostProvider[]
  daily: AiCostDaily[]
}

export interface ApiPriceConfig {
  id: number
  provider: string
  feature: string
  displayName: string
  unitPriceCny: number
  unitsPerCall: number
  freeQuota: number
  freeUntil: string | null
  enabled: number
  remark: string | null
}

export interface ApiUsageLog {
  id: number
  provider: string
  feature: string
  userId: number | null
  recordId: number | null
  success: number
  billable: number
  free: number
  units: number
  unitPriceCny: number
  costCny: number
  error: string | null
  createdAt: string
}
