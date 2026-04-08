/** 静态选项列表，供选择器滚轮切换（仅前端模拟） */
export const GENDER_OPTIONS = ['男', '女'] as const

export const AGE_OPTIONS = Array.from({ length: 100 }, (_, i) => `${i + 1}岁`)

export const HEIGHT_OPTIONS = Array.from({ length: 151 }, (_, i) => `${100 + i}cm`)

export const WEIGHT_JIN_OPTIONS = Array.from({ length: 341 }, (_, i) => `${40 + i}斤`)

export const WEEK_OPTIONS = Array.from({ length: 52 }, (_, i) => `${i + 1}周`)

export function indexOfLabel(options: string[], label: string): number {
  const i = options.indexOf(label)
  return i >= 0 ? i : Math.floor(options.length / 2)
}
