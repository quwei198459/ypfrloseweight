import type { FoodLibraryJson } from '@/api/food'

function toNum(v: unknown): number | null {
  if (v == null || v === '') return null
  const n = Number(v)
  return Number.isFinite(n) ? n : null
}

export interface FoodPickerRow {
  id: string
  name: string
  image?: string
  giLevel?: string
  caloriesText: string
  libraryId: number
  calories: number
  amountValue: number
  amountUnit: string
  proteinG: number
  fatG: number
  carbsG: number
}

function pickAmount(f: FoodLibraryJson): { value: number; unit: string } {
  const perUnit = toNum(f.caloriesPerUnit)
  if (perUnit != null && perUnit > 0) {
    return { value: 1, unit: (f.unitLabel && String(f.unitLabel)) || '份' }
  }
  const sw = toNum(f.standardWeightG)
  return { value: sw != null && sw > 0 ? sw : 100, unit: 'g' }
}

export function estimateFoodCalories(f: FoodLibraryJson): number {
  const perUnit = toNum(f.caloriesPerUnit)
  if (perUnit != null && perUnit > 0) return Math.round(perUnit)
  const per100 = toNum(f.caloriesPer100)
  const { value } = pickAmount(f)
  if (per100 != null && per100 > 0) {
    return Math.round((per100 * value) / 100)
  }
  return 0
}

function macrosForPick(f: FoodLibraryJson): { proteinG: number; fatG: number; carbsG: number } {
  const { value } = pickAmount(f)
  const p = toNum(f.protein) || 0
  const fat = toNum(f.fat) || 0
  const c = toNum(f.carbs) || 0
  const scale = value / 100
  return {
    proteinG: Math.round(p * scale * 10) / 10,
    fatG: Math.round(fat * scale * 10) / 10,
    carbsG: Math.round(c * scale * 10) / 10,
  }
}

export function formatFoodCaloriesText(f: FoodLibraryJson): string {
  const perUnit = toNum(f.caloriesPerUnit)
  const unit = (f.unitLabel && String(f.unitLabel)) || '份'
  if (perUnit != null && perUnit > 0) {
    return `${Math.round(perUnit)} 千卡 /1${unit}`
  }
  const per100 = toNum(f.caloriesPer100)
  if (per100 != null && per100 > 0) {
    return `${Math.round(per100)} 千卡 /100g`
  }
  return '—'
}

export function mapFoodLibraryToPickerRow(f: FoodLibraryJson): FoodPickerRow | null {
  const id = f.id
  if (id == null || !Number.isFinite(Number(id))) return null
  const name = (f.name && String(f.name).trim()) || '未命名'
  const { value, unit } = pickAmount(f)
  const m = macrosForPick(f)
  return {
    id: String(id),
    name,
    image: f.image,
    giLevel: f.giLevel,
    caloriesText: formatFoodCaloriesText(f),
    libraryId: Number(id),
    calories: estimateFoodCalories(f),
    amountValue: value,
    amountUnit: unit,
    proteinG: m.proteinG,
    fatG: m.fatG,
    carbsG: m.carbsG,
  }
}

export function mapFoodLibraryToPickerRows(list: FoodLibraryJson[]): FoodPickerRow[] {
  const out: FoodPickerRow[] = []
  for (const f of list) {
    const row = mapFoodLibraryToPickerRow(f)
    if (row) out.push(row)
  }
  return out
}
