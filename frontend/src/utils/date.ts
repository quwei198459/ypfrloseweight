/** 本地日历日期 YYYY-MM-DD（用于 dashboard 按日汇总） */
export function formatLocalDate(d: Date): string {
  const y = d.getFullYear()
  const m = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  return `${y}-${m}-${day}`
}

export function parseLocalYmd(ymd: string): Date {
  const [y, m, d] = ymd.split('-').map(Number)
  return new Date(y, m - 1, d)
}

/** ymd 上增减天数，仍为本时区日历日 */
export function addDaysToYmd(ymd: string, deltaDays: number): string {
  const dt = parseLocalYmd(ymd)
  dt.setDate(dt.getDate() + deltaDays)
  return formatLocalDate(dt)
}

/** 闭区间 [start, end] 内每一天的 ymd（要求 start <= end，均为 yyyy-MM-dd） */
export function enumerateYmdRange(start: string, end: string): string[] {
  const out: string[] = []
  let cur = start
  while (cur <= end) {
    out.push(cur)
    cur = addDaysToYmd(cur, 1)
  }
  return out
}
