import type { WeightRecordRow } from '@/api/types'

function toNum(v: unknown): number | null {
  if (v == null || v === '') return null
  const n = Number(v)
  return Number.isFinite(n) ? n : null
}

function recordDateStr(v: unknown): string {
  if (v == null) return ''
  const s = String(v)
  if (/^\d{4}-\d{2}-\d{2}$/.test(s)) return s
  const d = new Date(s)
  if (!Number.isNaN(d.getTime())) {
    const y = d.getFullYear()
    const m = String(d.getMonth() + 1).padStart(2, '0')
    const day = String(d.getDate()).padStart(2, '0')
    return `${y}-${m}-${day}`
  }
  return s
}

export function mapWeightRecordRow(raw: unknown): WeightRecordRow | null {
  if (raw == null || typeof raw !== 'object') return null
  const r = raw as Record<string, unknown>
  const kg = toNum(r.weightKg)
  if (kg == null || kg <= 0) return null
  const date = recordDateStr(r.recordDate)
  if (!date) return null
  const id = toNum(r.id)
  return {
    id: id != null ? Math.round(id) : undefined,
    recordDate: date,
    weightKg: kg,
  }
}

export function mapWeightRecordRows(list: unknown): WeightRecordRow[] {
  if (!Array.isArray(list)) return []
  const out: WeightRecordRow[] = []
  for (const x of list) {
    const row = mapWeightRecordRow(x)
    if (row) out.push(row)
  }
  return out
}
