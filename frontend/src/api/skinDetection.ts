import { apiPath } from '@/config/api'
import { httpGetAuth, httpPostAuth } from '@/utils/http'

export interface SkinDetectionQuotaVo {
  allowed: boolean
  phoneBound: boolean
  reason: string
  message: string
  totalTimes: number
  usedTimes: number
  remainingTimes: number
}

export interface SkinDetectionCreatePayload {
  imageBase64: string
  name?: string
  gender?: number
  birthday?: string
  age?: number
  residence?: string
}

export interface SkinDetectionCreateResponseVo {
  recordId: number
  status: string
  overallScore: number | null
  message: string
}

export interface SkinDetectionItemVo {
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

export interface SkinDetectionReportVo {
  recordId: number
  status: string
  failReason: string | null
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
  deepseekStatus: string | null
  deepseekError: string | null
  createdAt: string | null
  items: SkinDetectionItemVo[]
}

export interface SkinCustomerServiceVo {
  servicePhone: string | null
  serviceWechat: string | null
  serviceQrImageUrl: string | null
  serviceQrImagePath: string | null
  serviceQrImageName: string | null
  status?: number | null
  remark?: string | null
}

export function getSkinDetectionQuota(token: string): Promise<SkinDetectionQuotaVo> {
  return httpGetAuth<SkinDetectionQuotaVo>(apiPath('skin-detection/quota'), token)
}

export function createSkinDetectionRecord(
  token: string,
  body: SkinDetectionCreatePayload
): Promise<SkinDetectionCreateResponseVo> {
  return httpPostAuth<SkinDetectionCreateResponseVo>(
    apiPath('skin-detection/records'),
    body as Record<string, unknown>,
    token
  )
}

export function getSkinDetectionReport(
  token: string,
  recordId: number
): Promise<SkinDetectionReportVo> {
  return httpGetAuth<SkinDetectionReportVo>(apiPath(`skin-detection/records/${recordId}`), token)
}

export function getSkinCustomerService(token: string): Promise<SkinCustomerServiceVo> {
  return httpGetAuth<SkinCustomerServiceVo>(apiPath('skin-detection/customer-service/current'), token)
}
