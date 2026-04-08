/** 减脂趋势页静态 mock，后续可替换为接口 */
export const weightTrendMock = {
  initialWeight: 120,
  currentWeight: 162,
  targetWeight: 154,
  totalLoss: 0.0,
  currentWeightRecordText: '7天前记录',
  chart: {
    xAxis: ['02/03', '02/23', '03/02'] as const,
    yAxis: [120, 130, 140, 150, 160, 170] as const,
    points: [120, 160, 162] as const,
  },
} as const
