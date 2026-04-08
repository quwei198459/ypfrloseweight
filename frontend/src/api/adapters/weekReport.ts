import type { WeekStatsCardDto, WeekStatsDto } from '@/api/types'

function numArr(v: unknown): number[] {
  if (!Array.isArray(v)) return []
  return v.map((x) => Number(x)).filter((n) => Number.isFinite(n))
}

function mapCard(raw: unknown): WeekStatsCardDto | null {
  if (raw == null || typeof raw !== 'object') return null
  const c = raw as Record<string, unknown>
  const title = c.title != null ? String(c.title) : ''
  if (!title) return null
  const yAxis =
    numArr(c.yAxisLabels).length > 0
      ? numArr(c.yAxisLabels)
      : numArr((c as { yaxisLabels?: unknown }).yaxisLabels)
  const values = numArr(c.values)
  return {
    title,
    unitLabel: c.unitLabel != null ? String(c.unitLabel) : '',
    totalValue: Number(c.totalValue) || 0,
    totalSuffix: c.totalSuffix != null ? String(c.totalSuffix) : '',
    values,
    yAxisLabels: yAxis.length ? yAxis : [0, 1, 2],
    showGuideLine: Boolean(c.showGuideLine),
    guideValue: c.guideValue != null ? Number(c.guideValue) : undefined,
    guideLabel: c.guideLabel != null ? String(c.guideLabel) : undefined,
    barColor: c.barColor != null ? String(c.barColor) : undefined,
    guideColor: c.guideColor != null ? String(c.guideColor) : undefined,
    mode: (c.mode as WeekStatsCardDto['mode']) || undefined,
  }
}

/** 周统计卡片字段兜底，避免接口轻微变形导致图表异常 */
export function mapToWeekStatsDto(raw: WeekStatsDto | null | undefined): WeekStatsDto {
  if (!raw || !Array.isArray(raw.cards)) {
    return { cards: [] }
  }
  const cards: WeekStatsCardDto[] = []
  for (const x of raw.cards) {
    const m = mapCard(x)
    if (m) cards.push(m)
  }
  return { cards }
}
