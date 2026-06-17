/** 静态选项列表，供选择器滚轮切换（仅前端模拟） */
export const GENDER_OPTIONS = ['男', '女'] as const

export const AGE_OPTIONS = Array.from({ length: 100 }, (_, i) => `${i + 1}岁`)

export const HEIGHT_OPTIONS = Array.from({ length: 151 }, (_, i) => `${100 + i}cm`)

export const WEIGHT_KG_OPTIONS = Array.from({ length: 171 }, (_, i) => `${(30 + i * 0.5).toFixed(1)}公斤`)

export const WEEK_OPTIONS = Array.from({ length: 52 }, (_, i) => `${i + 1}周`)

export function indexOfLabel(options: string[], label: string): number {
  const i = options.indexOf(label)
  if (i >= 0) return i
  const target = Number((label || '').match(/\d+(?:\.\d+)?/)?.[0])
  if (Number.isFinite(target)) {
    let bestIndex = 0
    let bestDiff = Number.POSITIVE_INFINITY
    options.forEach((option, index) => {
      const value = Number(option.match(/\d+(?:\.\d+)?/)?.[0])
      if (!Number.isFinite(value)) return
      const diff = Math.abs(value - target)
      if (diff < bestDiff) {
        bestDiff = diff
        bestIndex = index
      }
    })
    return bestIndex
  }
  return Math.floor(options.length / 2)
}
