/** 热量查询 / 食物搜索结果展示模型（与后端、适配器共用，避免仅类型引用导致 mp 打包无对应 js） */
export type GiLevel = 'low' | 'medium' | 'high'

export interface SearchFoodItem {
  id: string
  name: string
  calorie: number
  unit: string
  giLevel: GiLevel
  image: string
  /** 弹层顶部摘要，如「864.0 千卡/12个」 */
  calorieSummary?: string
  carbsG?: number
  proteinG?: number
  fatG?: number
  /** true：calorie 为每 100g 千卡；false：calorie 为「每份」千卡（见 servingWeightG） */
  calorieIsPer100g: boolean
  /** 按份时一份参考克数，用于把弹层「克」换算成热量 */
  servingWeightG: number
}
