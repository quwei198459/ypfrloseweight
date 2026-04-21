/** 减脂趋势页默认展示（无接口数据时）；运行时使用 reactive 拷贝，可安全修改 */
export function createWeightTrendState() {
  return {
    initialWeight: 0,
    currentWeight: 0,
    targetWeight: 0,
    totalLoss: 0,
    currentWeightRecordText: '—',
    chart: {
      xAxis: [] as string[],
      yAxis: [] as number[],
      yMin: 120,
      yMax: 170,
      points: [] as number[],
    },
  }
}
