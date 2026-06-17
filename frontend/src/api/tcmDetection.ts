import { apiPath } from '@/config/api'
import { httpGetAuth, httpPostAuth } from '@/utils/http'

export interface TcmDetectionQuotaVo {
  allowed: boolean
  phoneBound?: boolean
  reason: string
  message: string
  totalTimes: number
  usedTimes: number
  remainingTimes: number
}

/** scene: 1=问诊更准（返回问诊题目），2=快速出报告（默认，直接出报告） */
export type TcmDetectionScene = 1 | 2

export interface TcmDetectionCreatePayload {
  scene?: TcmDetectionScene
  tongueImageBase64: string
  faceImageBase64: string
  name?: string
  gender?: number
  birthday?: string
  age?: number
  residence?: string
}

/** 问诊题目 / 答案项 */
export interface TcmInquiryItem {
  name: string
  value: string
}

export interface TcmDetectionCreateResponseVo {
  recordId: number
  /** success | pending_inquiry | failed */
  status: string
  overallScore: number | null
  constitutionPrimary: string | null
  message: string
  inquiryQuestions?: TcmInquiryItem[]
}

export interface TcmDetectionInquiryResponseVo {
  recordId: number
  status: string
  overallScore: number | null
  constitutionPrimary: string | null
  message: string
}

/** 望诊特征项（items）：itemName=特征名，level=正常/异常，scaleType=面部/舌部 */
export interface TcmDetectionItemVo {
  itemCode: string
  itemName: string
  level: string | null
  resultText: string | null
  scaleType: string | null
  /** JSON 字符串：{group,featureName,situation,category} */
  metricsJson: string | null
  sortOrder: number | null
}

/** metricsJson 解析后的结构 */
export interface TcmItemMetrics {
  group?: string
  featureName?: string
  situation?: string
  category?: string
}

/** reportJson.advices 内每条建议 */
export interface TcmAdviceItem {
  title: string
  advice: string
}

/** reportJson.goods 推荐商品 */
export interface TcmGoodsItem {
  name: string
  img1?: string
  introduction?: string
}

/** reportJson 解析后的结构（reportJson 本身是字符串） */
export interface TcmReportJson {
  physiqueName?: string
  physiqueAnalysis?: string
  typicalSymptom?: string
  riskWarning?: string
  syndromeName?: string
  syndromeIntroduction?: string
  advices?: {
    food?: TcmAdviceItem[]
    music?: TcmAdviceItem[]
    sleep?: TcmAdviceItem[]
    sport?: TcmAdviceItem[]
    treatment?: TcmAdviceItem[]
  }
  goods?: TcmGoodsItem[]
  annotatedTongueUrl?: string
}

export interface TcmDetectionReportVo {
  recordId: number
  status: string
  failReason: string | null
  userName: string | null
  gender: number | null
  age: number | null
  tongueImageUrl: string | null
  faceImageUrl: string | null
  /** 主体质，如 "气虚体质、痰湿体质" */
  constitutionPrimary: string | null
  /** 综合分 0-100 */
  overallScore: number | null
  /** DeepSeek 口语化总结（可能为空，做降级） */
  aiSummary: string | null
  deepseekStatus: string | null
  deepseekError: string | null
  /** JSON 字符串，需 JSON.parse */
  reportJson: string | null
  createdAt: string | null
  /** 望诊特征 */
  items: TcmDetectionItemVo[]
}

export interface TcmCustomerServiceVo {
  servicePhone: string | null
  serviceWechat: string | null
  serviceQrImageUrl: string | null
  serviceQrImagePath: string | null
  serviceQrImageName: string | null
  status?: number | null
  remark?: string | null
}

export function getTcmDetectionQuota(token: string): Promise<TcmDetectionQuotaVo> {
  return httpGetAuth<TcmDetectionQuotaVo>(apiPath('tcm-detection/quota'), token)
}

export function createTcmDetectionRecord(
  token: string,
  body: TcmDetectionCreatePayload
): Promise<TcmDetectionCreateResponseVo> {
  return httpPostAuth<TcmDetectionCreateResponseVo>(
    apiPath('tcm-detection/records'),
    body as unknown as Record<string, unknown>,
    token
  )
}

export function submitTcmInquiry(
  token: string,
  recordId: number,
  body: { answers: TcmInquiryItem[] }
): Promise<TcmDetectionInquiryResponseVo> {
  return httpPostAuth<TcmDetectionInquiryResponseVo>(
    apiPath(`tcm-detection/records/${recordId}/inquiry`),
    body as unknown as Record<string, unknown>,
    token
  )
}

export function getTcmDetectionReport(
  token: string,
  recordId: number
): Promise<TcmDetectionReportVo> {
  return httpGetAuth<TcmDetectionReportVo>(apiPath(`tcm-detection/records/${recordId}`), token)
}

export function getTcmCustomerService(token: string): Promise<TcmCustomerServiceVo> {
  return httpGetAuth<TcmCustomerServiceVo>(apiPath('tcm-detection/customer-service/current'), token)
}
