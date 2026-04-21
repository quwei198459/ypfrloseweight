/** 计划页「真实用户案例」轮播用静态条目（头像用色块 + 首字，数据为展示用） */
export interface PlanUserCaseSlide {
  id: number
  /** 展示周数 */
  weeks: number
  /** 减重斤数 */
  loss: number
  /** 达成月 */
  month: number
  /** 达成日 */
  day: number
  /** 头像首字 */
  initial: string
  /** HSL 色相 0–360 */
  hue: number
}

const initials = '陈林王张刘赵黄周吴徐孙马朱胡郭何高罗郑梁谢宋唐许韩冯邓曹彭曾萧田董潘袁蔡蒋余于杜叶程苏魏吕丁任沈姚卢姜崔钟谭陆汪范金石廖贾夏付方邹熊白孟秦江阎薛尹段雷侯龙史陶黎贺顾毛郝龚邵万钱严覃武戴莫孔向汤'.split(
  '',
)

function pseudoRandom(seed: number): number {
  const x = Math.sin(seed) * 10000
  return x - Math.floor(x)
}

export function buildPlanUserCaseSlides(count = 20): PlanUserCaseSlide[] {
  const out: PlanUserCaseSlide[] = []
  for (let i = 0; i < count; i++) {
    const r1 = pseudoRandom(i * 17 + 3)
    const r2 = pseudoRandom(i * 31 + 7)
    const r3 = pseudoRandom(i * 13 + 11)
    const weeks = 8 + Math.floor(r1 * 17)
    const loss = Math.round((3 + r2 * 18) * 10) / 10
    const month = 1 + Math.floor(r3 * 12)
    const day = 1 + Math.floor(pseudoRandom(i * 41 + 5) * 28)
    out.push({
      id: i + 1,
      weeks,
      loss,
      month,
      day,
      initial: initials[i % initials.length] ?? '用',
      hue: Math.floor(pseudoRandom(i * 59 + 2) * 360),
    })
  }
  return out
}
