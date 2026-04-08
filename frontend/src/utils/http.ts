import { API_BASE_URL } from '@/config/api'

interface ApiEnvelope<T> {
  code: number
  message: string
  data: T
}

function handleSuccess<T>(
  res: UniApp.RequestSuccessCallbackResult,
  resolve: (v: T) => void,
  reject: (e: Error) => void
) {
  const body = res.data as ApiEnvelope<T>
  if (body && typeof body.code === 'number') {
    if (body.code !== 0) {
      reject(new Error(body.message || '请求失败'))
      return
    }
    if (res.statusCode === 200) {
      resolve(body.data)
      return
    }
  }
  reject(new Error(res.statusCode === 200 ? '数据格式异常' : `网络错误 ${res.statusCode}`))
}

export function httpGet<T>(path: string): Promise<T> {
  const url = `${API_BASE_URL}${path.startsWith('/') ? path : `/${path}`}`
  return new Promise((resolve, reject) => {
    uni.request({
      url,
      method: 'GET',
      success(res) {
        handleSuccess<T>(res, resolve, reject)
      },
      fail(err) {
        reject(new Error(err.errMsg || '网络不可用'))
      },
    })
  })
}

export function httpGetAuth<T>(path: string, token: string): Promise<T> {
  const url = `${API_BASE_URL}${path.startsWith('/') ? path : `/${path}`}`
  return new Promise((resolve, reject) => {
    uni.request({
      url,
      method: 'GET',
      header: {
        Authorization: `Bearer ${token}`,
      },
      success(res) {
        handleSuccess<T>(res, resolve, reject)
      },
      fail(err) {
        reject(new Error(err.errMsg || '网络不可用'))
      },
    })
  })
}

export function httpPost<T>(path: string, body: Record<string, unknown>): Promise<T> {
  const url = `${API_BASE_URL}${path.startsWith('/') ? path : `/${path}`}`
  return new Promise((resolve, reject) => {
    uni.request({
      url,
      method: 'POST',
      header: {
        'Content-Type': 'application/json',
      },
      data: body,
      success(res) {
        handleSuccess<T>(res, resolve, reject)
      },
      fail(err) {
        reject(new Error(err.errMsg || '网络不可用'))
      },
    })
  })
}

export function httpPostAuth<T>(
  path: string,
  body: Record<string, unknown>,
  token: string
): Promise<T> {
  const url = `${API_BASE_URL}${path.startsWith('/') ? path : `/${path}`}`
  return new Promise((resolve, reject) => {
    uni.request({
      url,
      method: 'POST',
      header: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
      },
      data: body,
      success(res) {
        handleSuccess<T>(res, resolve, reject)
      },
      fail(err) {
        reject(new Error(err.errMsg || '网络不可用'))
      },
    })
  })
}

export function httpDeleteAuth<T>(path: string, token: string): Promise<T> {
  const url = `${API_BASE_URL}${path.startsWith('/') ? path : `/${path}`}`
  return new Promise((resolve, reject) => {
    uni.request({
      url,
      method: 'DELETE',
      header: {
        Authorization: `Bearer ${token}`,
      },
      success(res) {
        handleSuccess<T>(res, resolve, reject)
      },
      fail(err) {
        reject(new Error(err.errMsg || '网络不可用'))
      },
    })
  })
}
