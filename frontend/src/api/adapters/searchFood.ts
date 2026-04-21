import { API_BASE_URL } from '@/config/api'
import { FOOD_IMAGE_PLACEHOLDER } from '@/constants/foodImage'
import type { FoodLibraryJson } from '@/api/food'
import type { SearchFoodItem } from '@/types/searchFood'
import { estimateFoodCalories, formatFoodCaloriesText } from '@/api/adapters/foodPicker'

function toNum(v: unknown): number | null {
  if (v == null || v === '') return null
  const n = Number(v)
  return Number.isFinite(n) ? n : null
}

function mapGiOptional(gi?: string): GiLevel | undefined {
  const s = (gi || '').trim().toLowerCase()
  if (!s) return undefined
  if (/低|low|l/.test(s)) return 'low'
  if (/高|high|h/.test(s)) return 'high'
  if (/中|medium|m/.test(s)) return 'medium'
  return undefined
}

function resolveImageUrl(image?: string): string {
  const raw = (image || '').trim()
  if (!raw) return FOOD_IMAGE_PLACEHOLDER
  const u = String(raw)
  if (u.startsWith('http://') || u.startsWith('https://')) return u
  return `${API_BASE_URL}${u.startsWith('/') ? '' : '/'}${u}`
}

export function mapFoodToSearchItem(f: FoodLibraryJson): SearchFoodItem | null {
  const id = f.id
  if (id == null) return null
  const per100 = toNum(f.caloriesPer100)
  const perUnit = toNum(f.caloriesPerUnit)
  const name = (f.name && String(f.name).trim()) || '未命名'
  const portionUnit = (f.unitLabel && String(f.unitLabel).trim()) || '份'
  const unit =
    perUnit != null && perUnit > 0
      ? `千卡/1${portionUnit}`
      : '千卡/100g'
  const p = toNum(f.protein)
  const fat = toNum(f.fat)
  const c = toNum(f.carbs)

  let calorie: number
  let calorieIsPer100g: boolean
  let servingWeightG: number
  if (per100 != null && per100 > 0) {
    calorie = Math.round(per100)
    calorieIsPer100g = true
    const sw = toNum(f.standardWeightG)
    servingWeightG = sw != null && sw > 0 ? sw : 100
  } else {
    calorie = Math.round(estimateFoodCalories(f))
    calorieIsPer100g = false
    const sw = toNum(f.standardWeightG)
    servingWeightG = sw != null && sw > 0 ? sw : 100
  }

  return {
    id: String(id),
    name,
    calorie,
    unit,
    portionUnitLabel: portionUnit,
    giLevel: mapGiOptional(f.giLevel),
    image: resolveImageUrl(f.image),
    calorieSummary: formatFoodCaloriesText(f),
    carbsG: c ?? undefined,
    proteinG: p ?? undefined,
    fatG: fat ?? undefined,
    calorieIsPer100g,
    servingWeightG,
  }
}

export function mapFoodsToSearchItems(list: FoodLibraryJson[]): SearchFoodItem[] {
  const out: SearchFoodItem[] = []
  for (const f of list) {
    const it = mapFoodToSearchItem(f)
    if (it) out.push(it)
  }
  return out
}
