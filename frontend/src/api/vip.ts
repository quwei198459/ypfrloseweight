import { apiPath } from '@/config/api'
import { httpGet } from '@/utils/http'

export interface VipProductDto {
  code: string
  title: string
  subtitle: string | null
  priceYuan: number
  originPriceYuan: number
  durationDays: number
  cornerTag: string | null
}

function num(v: unknown): number {
  if (v == null) return 0
  const n = Number(v)
  return Number.isFinite(n) ? n : 0
}

function mapVipProduct(raw: Record<string, unknown>): VipProductDto {
  return {
    code: String(raw.code ?? ''),
    title: String(raw.title ?? ''),
    subtitle: raw.subtitle != null ? String(raw.subtitle) : null,
    priceYuan: num(raw.priceYuan),
    originPriceYuan: num(raw.originPriceYuan),
    durationDays: Math.round(num(raw.durationDays)),
    cornerTag: raw.cornerTag != null ? String(raw.cornerTag) : null,
  }
}

/** GET /api/v1/vip/products */
export function fetchVipProducts(): Promise<VipProductDto[]> {
  return httpGet<unknown[]>(apiPath('vip/products')).then((list) =>
    Array.isArray(list) ? list.map((x) => mapVipProduct(x as Record<string, unknown>)) : [],
  )
}
