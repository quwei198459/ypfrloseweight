import type {
  AdminDashboardStats,
  AdminLoginPayload,
  AdminLoginResult,
  AdminPagedResult,
  AdminUserItem,
  ApiResponse,
  FoodCategoryItem,
  FoodItem,
  SportItem,
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
