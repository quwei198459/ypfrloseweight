export type WeekMetricChartKind = 'deficit' | 'positive' | 'empty'

export interface WeekMetricChartCardProps {
  title: string
  unitLabel: string
  totalValue: number | string
  totalSuffix: string
  dates: string[]
  values: number[]
  yAxisLabels: (number | string)[]
  showGuideLine?: boolean
  guideValue?: number
  guideLabel?: string
  barColor?: string
  guideColor?: string
  /** 图表语义：负值缺口 / 正向数值 / 全空 */
  mode?: WeekMetricChartKind
}
