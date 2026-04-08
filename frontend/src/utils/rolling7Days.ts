/**
 * 「近 7 日」统计区间：**含今天**，再往前连续 6 天（共 7 个自然日，按设备本地时区）。
 * 与「自然周周一～周日」无关。
 */

function pad2(n: number): string {
  return n < 10 ? `0${n}` : String(n)
}

/** 本地日历日 → yyyy-MM-dd */
export function toLocalYmd(d: Date): string {
  return `${d.getFullYear()}-${pad2(d.getMonth() + 1)}-${pad2(d.getDate())}`
}

/** 解析 yyyy-MM-dd 为本地 Date（当天 0 点） */
export function parseLocalYmd(ymd: string): Date {
  const [y, m, day] = ymd.split('-').map(Number)
  return new Date(y, m - 1, day)
}

export interface Rolling7DaysRange {
  /** 区间起点（6 天前），yyyy-MM-dd */
  startDate: string
  /** 区间终点（今天），yyyy-MM-dd */
  endDate: string
  /** 横轴展示，与 values 下标一一对应，如 3.28、3.29 … */
  chartDateLabels: string[]
}

/**
 * 计算近 7 日闭区间 [today-6, today]（本地时区）。
 * @param now 可选，便于单测；默认 new Date()
 */
export function getRolling7DaysRange(now: Date = new Date()): Rolling7DaysRange {
  const end = new Date(now.getFullYear(), now.getMonth(), now.getDate())
  const start = new Date(end)
  start.setDate(start.getDate() - 6)

  const startDate = toLocalYmd(start)
  const endDate = toLocalYmd(end)

  const chartDateLabels: string[] = []
  for (let i = 0; i < 7; i++) {
    const d = new Date(start.getFullYear(), start.getMonth(), start.getDate() + i)
    chartDateLabels.push(`${d.getMonth() + 1}.${d.getDate()}`)
  }

  return { startDate, endDate, chartDateLabels }
}

/**
 * 顶部文案，与历史 mock 风格一致：2026.3.28–4.3（同年可省略结束日年份）
 */
export function formatRollingRangeLabel(startDate: string, endDate: string): string {
  const s = parseLocalYmd(startDate)
  const e = parseLocalYmd(endDate)
  const sy = s.getFullYear()
  const ey = e.getFullYear()
  const sm = s.getMonth() + 1
  const sd = s.getDate()
  const em = e.getMonth() + 1
  const ed = e.getDate()
  if (sy === ey) {
    return `${sy}.${sm}.${sd}–${em}.${ed}`
  }
  return `${sy}.${sm}.${sd}–${ey}.${em}.${ed}`
}
