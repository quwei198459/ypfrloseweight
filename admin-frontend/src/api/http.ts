import axios from 'axios'
import { useAuthStore } from '../stores/auth'

/** 与页面同源；完整路径形如 /api/v1/admin/login，由 Nginx 反代到后端 */
const baseURL = import.meta.env.VITE_API_BASE_URL || '/api/v1'

export const http = axios.create({
  baseURL,
  timeout: 15000,
})

http.interceptors.request.use((config) => {
  const auth = useAuthStore()
  if (auth.token) {
    config.headers.Authorization = `Bearer ${auth.token}`
  }
  return config
})

http.interceptors.response.use(
  (r) => r,
  (err: unknown) => {
    const ax = err as { response?: { data?: { message?: string } } }
    const msg = ax.response?.data?.message
    if (typeof msg === 'string' && msg.trim()) {
      return Promise.reject(new Error(msg))
    }
    return Promise.reject(err)
  },
)
