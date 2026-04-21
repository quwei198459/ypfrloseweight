/** 开通页「最近购买」跑马灯文案（展示用，50 条循环） */
const surnames =
  '赵钱孙李周吴郑王冯陈褚卫蒋沈韩杨朱秦尤许何吕施张孔曹严华金魏陶姜戚谢邹喻柏水窦章云苏潘葛奚范彭郎鲁韦昌马苗凤花方俞任袁柳酆鲍史唐'.split(
    '',
  )

const tierLabels = ['永久会员', '季度会员', '年费会员']
const verbs = ['成为了', '开通了', '已加入']

function seedStr(i: number): string {
  const a = surnames[i % surnames.length] ?? '用'
  const b = surnames[(i * 7 + 3) % surnames.length] ?? '户'
  return `${a}${b}**`
}

export function buildMemberPurchaseNotices(count = 50): string[] {
  const out: string[] = []
  for (let i = 0; i < count; i++) {
    const name = seedStr(i)
    const tier = tierLabels[i % tierLabels.length] ?? '会员'
    const verb = verbs[i % verbs.length] ?? '成为了'
    out.push(`${name}${verb}${tier}`)
  }
  return out
}
