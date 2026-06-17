import type {
  AdminDashboardStats,
  AdminLoginPayload,
  AdminLoginResult,
  AdminPagedResult,
  AdminUserItem,
  ApiResponse,
  FoodCategoryItem,
  FoodItem,
  PhotoRecognitionMemberPhone,
  PhotoRecognitionQuotaLogItem,
  PhotoRecognitionQuotaSummary,
  PhotoRecognitionServiceConfig,
  SkinDetectionQuotaLogItem,
  SkinDetectionQuotaSummary,
  SkinDetectionAiPromptTemplate,
  SkinDetectionItemConfig,
  SkinDetectionRecord,
  SkinDetectionRecordDetail,
  SkinDetectionWhitelist,
  SportItem,
  SystemConfig,
  TcmDetectionQuotaLogItem,
  TcmDetectionQuotaSummary,
  TcmDetectionAiPromptTemplate,
  TcmDetectionItemConfig,
  TcmDetectionRecord,
  TcmDetectionRecordDetail,
  TcmDetectionWhitelist,
} from '../types/admin'
import { http } from './http'

async function unwrap<T>(promise: Promise<{ data: ApiResponse<T> }>): Promise<T> {
  const resp = await promise
  if (resp.data.code !== 0) {
    throw new Error(resp.data.message || '请求失败')
  }
  return resp.data.data
}

export function adminLogin(payload: AdminLoginPayload) {
  return unwrap<AdminLoginResult>(http.post('/admin/login', payload))
}

export function adminChangePassword(payload: { oldPassword: string; newPassword: string }) {
  return unwrap<boolean>(http.post('/admin/change-password', payload))
}

export function fetchAdminDashboardStats() {
  return unwrap<AdminDashboardStats>(http.get('/admin/dashboard/stats'))
}

export function fetchAdminUsers(params: { keyword?: string; page: number; pageSize: number }) {
  return unwrap<AdminPagedResult<AdminUserItem>>(http.get('/admin/users', { params }))
}

export function fetchFoodCategories() {
  return unwrap<FoodCategoryItem[]>(http.get('/admin/food-categories'))
}

export function createFoodCategory(payload: FoodCategoryItem) {
  return unwrap<FoodCategoryItem>(http.post('/admin/food-categories', payload))
}

export function updateFoodCategory(id: number, payload: FoodCategoryItem) {
  return unwrap<FoodCategoryItem>(http.put(`/admin/food-categories/${id}`, payload))
}

export function deleteFoodCategory(id: number) {
  return unwrap<boolean>(http.delete(`/admin/food-categories/${id}`))
}

export function fetchFoods(params: { keyword?: string; status?: number }) {
  return unwrap<FoodItem[]>(http.get('/admin/foods', { params }))
}

export function createFood(payload: FoodItem) {
  return unwrap<FoodItem>(http.post('/admin/foods', payload))
}

export function updateFood(id: number, payload: FoodItem) {
  return unwrap<FoodItem>(http.put(`/admin/foods/${id}`, payload))
}

export function deleteFood(id: number) {
  return unwrap<boolean>(http.delete(`/admin/foods/${id}`))
}

export function fetchSports(params: { keyword?: string; status?: number }) {
  return unwrap<SportItem[]>(http.get('/admin/sports', { params }))
}

export function createSport(payload: SportItem) {
  return unwrap<SportItem>(http.post('/admin/sports', payload))
}

export function updateSport(id: number, payload: SportItem) {
  return unwrap<SportItem>(http.put(`/admin/sports/${id}`, payload))
}

export function deleteSport(id: number) {
  return unwrap<boolean>(http.delete(`/admin/sports/${id}`))
}

export function fetchPhotoRecognitionMembers(params: { keyword?: string; status?: number }) {
  return unwrap<PhotoRecognitionMemberPhone[]>(http.get('/admin/photo-recognition-members', { params }))
}

export function createPhotoRecognitionMember(payload: {
  phone: string
  remark?: string | null
  status: number
  totalQuota?: number
}) {
  return unwrap<PhotoRecognitionMemberPhone>(http.post('/admin/photo-recognition-members', payload))
}

export function updatePhotoRecognitionMember(
  id: number,
  payload: { phone: string; remark?: string | null; status: number; totalQuota?: number },
) {
  return unwrap<PhotoRecognitionMemberPhone>(http.put(`/admin/photo-recognition-members/${id}`, payload))
}

export function deletePhotoRecognitionMember(id: number) {
  return unwrap<boolean>(http.delete(`/admin/photo-recognition-members/${id}`))
}

export function adjustPhotoRecognitionMemberQuota(id: number, payload: { delta: number; remark?: string }) {
  return unwrap<PhotoRecognitionMemberPhone>(http.post(`/admin/photo-recognition-members/${id}/quota-adjustments`, payload))
}

export function fetchPhotoRecognitionMemberQuotaSummary(id: number) {
  return unwrap<PhotoRecognitionQuotaSummary>(http.get(`/admin/photo-recognition-members/${id}/quota-summary`))
}

export function fetchPhotoRecognitionMemberManualLogs(id: number) {
  return unwrap<PhotoRecognitionQuotaLogItem[]>(http.get(`/admin/photo-recognition-members/${id}/quota-logs/manual`))
}

export function fetchPhotoRecognitionMemberConsumeLogs(id: number) {
  return unwrap<PhotoRecognitionQuotaLogItem[]>(http.get(`/admin/photo-recognition-members/${id}/quota-logs/consume`))
}

export function fetchPhotoRecognitionServiceConfig() {
  return unwrap<PhotoRecognitionServiceConfig>(http.get('/admin/photo-recognition-service-config'))
}

export function updatePhotoRecognitionServiceConfig(payload: {
  servicePhone: string
  serviceWechat: string
  serviceQrImageUrl?: string
  serviceQrImageFile?: File
  remark?: string
  status?: number
}) {
  const form = new FormData()
  form.append('servicePhone', payload.servicePhone)
  form.append('serviceWechat', payload.serviceWechat)
  if (payload.serviceQrImageUrl) form.append('serviceQrImageUrl', payload.serviceQrImageUrl)
  if (payload.serviceQrImageFile) form.append('serviceQrImageFile', payload.serviceQrImageFile)
  if (payload.remark) form.append('remark', payload.remark)
  if (payload.status !== undefined) form.append('status', String(payload.status))
  return unwrap<PhotoRecognitionServiceConfig>(http.post('/admin/photo-recognition-service-config', form))
}

export function fetchSkinDetectionWhitelist(params: { keyword?: string; status?: number }) {
  return unwrap<SkinDetectionWhitelist[]>(http.get('/admin/skin-detection-whitelist', { params }))
}

export function createSkinDetectionWhitelist(payload: {
  phone: string
  remark?: string | null
  status: number
  totalTimes?: number
}) {
  return unwrap<SkinDetectionWhitelist>(http.post('/admin/skin-detection-whitelist', payload))
}

export function updateSkinDetectionWhitelist(
  id: number,
  payload: { phone: string; remark?: string | null; status: number; totalTimes?: number },
) {
  return unwrap<SkinDetectionWhitelist>(http.put(`/admin/skin-detection-whitelist/${id}`, payload))
}

export function adjustSkinDetectionQuota(id: number, payload: { delta: number; remark?: string }) {
  return unwrap<SkinDetectionWhitelist>(http.post(`/admin/skin-detection-whitelist/${id}/quota-adjustments`, payload))
}

export function fetchSkinDetectionQuotaSummary(id: number) {
  return unwrap<SkinDetectionQuotaSummary>(http.get(`/admin/skin-detection-whitelist/${id}/quota-summary`))
}

export function fetchSkinDetectionManualLogs(id: number) {
  return unwrap<SkinDetectionQuotaLogItem[]>(http.get(`/admin/skin-detection-whitelist/${id}/quota-logs/manual`))
}

export function fetchSkinDetectionConsumeLogs(id: number) {
  return unwrap<SkinDetectionQuotaLogItem[]>(http.get(`/admin/skin-detection-whitelist/${id}/quota-logs/consume`))
}

export function fetchSkinDetectionItemConfigs() {
  return unwrap<SkinDetectionItemConfig[]>(http.get('/admin/skin-detection-config/items'))
}

export function updateSkinDetectionItemConfig(id: number, payload: {
  itemName: string
  displayName: string
  sortOrder: number
  enabled: number
  scaleType: string
  scoreDirection: string
  promptKey: string
  remark?: string | null
}) {
  return unwrap<SkinDetectionItemConfig>(http.put(`/admin/skin-detection-config/items/${id}`, payload))
}

export function fetchSkinDetectionAiPrompts() {
  return unwrap<SkinDetectionAiPromptTemplate[]>(http.get('/admin/skin-detection-config/ai-prompts'))
}

export function updateSkinDetectionAiPrompt(id: number, payload: {
  promptName: string
  templateContent: string
  outputSchema?: string | null
  model: string
  temperature: number
  status: number
  remark?: string | null
}) {
  return unwrap<SkinDetectionAiPromptTemplate>(http.put(`/admin/skin-detection-config/ai-prompts/${id}`, payload))
}

export function fetchSkinDetectionRecords(params: {
  phone?: string
  status?: string
  startDate?: string
  endDate?: string
  minScore?: number
  maxScore?: number
}) {
  return unwrap<SkinDetectionRecord[]>(http.get('/admin/skin-detection-records', { params }))
}

export function fetchSkinDetectionRecordDetail(id: number) {
  return unwrap<SkinDetectionRecordDetail>(http.get(`/admin/skin-detection-records/${id}`))
}

export async function downloadSkinDetectionRecordPdf(id: number) {
  const resp = await http.get(`/admin/skin-detection-records/${id}/pdf`, { responseType: 'blob' })
  return resp.data as Blob
}

export function fetchTcmDetectionWhitelist(params: { keyword?: string; status?: number }) {
  return unwrap<TcmDetectionWhitelist[]>(http.get('/admin/tcm-detection-whitelist', { params }))
}

export function createTcmDetectionWhitelist(payload: {
  phone: string
  remark?: string | null
  status: number
  totalTimes?: number
}) {
  return unwrap<TcmDetectionWhitelist>(http.post('/admin/tcm-detection-whitelist', payload))
}

export function updateTcmDetectionWhitelist(
  id: number,
  payload: { phone: string; remark?: string | null; status: number; totalTimes?: number },
) {
  return unwrap<TcmDetectionWhitelist>(http.put(`/admin/tcm-detection-whitelist/${id}`, payload))
}

export function adjustTcmDetectionQuota(id: number, payload: { delta: number; remark?: string }) {
  return unwrap<TcmDetectionWhitelist>(http.post(`/admin/tcm-detection-whitelist/${id}/quota-adjustments`, payload))
}

export function fetchTcmDetectionQuotaSummary(id: number) {
  return unwrap<TcmDetectionQuotaSummary>(http.get(`/admin/tcm-detection-whitelist/${id}/quota-summary`))
}

export function fetchTcmDetectionManualLogs(id: number) {
  return unwrap<TcmDetectionQuotaLogItem[]>(http.get(`/admin/tcm-detection-whitelist/${id}/quota-logs/manual`))
}

export function fetchTcmDetectionConsumeLogs(id: number) {
  return unwrap<TcmDetectionQuotaLogItem[]>(http.get(`/admin/tcm-detection-whitelist/${id}/quota-logs/consume`))
}

export function fetchTcmDetectionItemConfigs() {
  return unwrap<TcmDetectionItemConfig[]>(http.get('/admin/tcm-detection-config/items'))
}

export function updateTcmDetectionItemConfig(id: number, payload: {
  itemName: string
  displayName: string
  sortOrder: number
  enabled: number
  scaleType: string
  scoreDirection: string
  promptKey: string
  remark?: string | null
}) {
  return unwrap<TcmDetectionItemConfig>(http.put(`/admin/tcm-detection-config/items/${id}`, payload))
}

export function fetchTcmDetectionAiPrompts() {
  return unwrap<TcmDetectionAiPromptTemplate[]>(http.get('/admin/tcm-detection-config/ai-prompts'))
}

export function updateTcmDetectionAiPrompt(id: number, payload: {
  promptName: string
  templateContent: string
  outputSchema?: string | null
  model: string
  temperature: number
  status: number
  remark?: string | null
}) {
  return unwrap<TcmDetectionAiPromptTemplate>(http.put(`/admin/tcm-detection-config/ai-prompts/${id}`, payload))
}

export function fetchTcmDetectionRecords(params: {
  phone?: string
  status?: string
  startDate?: string
  endDate?: string
  minScore?: number
  maxScore?: number
}) {
  return unwrap<TcmDetectionRecord[]>(http.get('/admin/tcm-detection-records', { params }))
}

export function fetchTcmDetectionRecordDetail(id: number) {
  return unwrap<TcmDetectionRecordDetail>(http.get(`/admin/tcm-detection-records/${id}`))
}

export async function downloadTcmDetectionRecordPdf(id: number) {
  const resp = await http.get(`/admin/tcm-detection-records/${id}/pdf`, { responseType: 'blob' })
  return resp.data as Blob
}

export function fetchSystemConfig() {
  return unwrap<SystemConfig>(http.get('/admin/system-config'))
}

export function updateSystemConfig(payload: Partial<SystemConfig>) {
  return unwrap<SystemConfig>(http.put('/admin/system-config', payload))
}

