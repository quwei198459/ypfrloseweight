import type { SportLibraryJson } from '@/api/sport'

function toNum(v: unknown): number | null {
  if (v == null || v === '') return null
  const n = Number(v)
  return Number.isFinite(n) ? n : null
}

export interface SportPickerRow {
  id: string
  name: string
  caloriesText: string
  caloriesPerMin: number
  icon?: string
}

export function mapSportToPickerRow(s: SportLibraryJson): SportPickerRow | null {
  const id = s.id
  if (id == null) return null
  const name = (s.name && String(s.name).trim()) || '运动'
  const perMin = toNum(s.caloriesPerMin) ?? 0
  const per60 = Math.round(perMin * 60)
  return {
    id: String(id),
    name,
    caloriesText: per60 > 0 ? `${per60} 千卡 /60分钟` : '—',
    caloriesPerMin: perMin,
    icon: s.icon ? String(s.icon) : undefined,
  }
}

export function mapSportsToPickerRows(list: SportLibraryJson[]): SportPickerRow[] {
  const out: SportPickerRow[] = []
  for (const x of list) {
    const r = mapSportToPickerRow(x)
    if (r) out.push(r)
  }
  return out
}
