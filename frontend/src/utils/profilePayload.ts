/** 将个人信息页展示文案解析为后端 UpdateProfilePayload 所需数值 */

export function genderLabelToCode(g: string): number | undefined {
  if (g === '男') return 1
  if (g === '女') return 2
  return undefined
}

export function parseAgeLabel(s: string): number | undefined {
  const m = /^(\d+)岁$/.exec((s || '').trim())
  return m ? parseInt(m[1], 10) : undefined
}

export function parseHeightCm(s: string): number | undefined {
  const m = /^(\d+(?:\.\d+)?)cm$/.exec((s || '').trim())
  return m ? parseFloat(m[1]) : undefined
}

export function parseWeightKgFromJinLabel(s: string): number | undefined {
  const m = /^(\d+(?:\.\d+)?)斤$/.exec((s || '').trim())
  return m ? parseFloat(m[1]) / 2 : undefined
}

/** 支持 yyyy-MM-dd 或「N周」估算日期 */
export function parseTargetDateIso(s: string): string | undefined {
  if (!s) return undefined
  const t = s.trim()
  if (/^\d{4}-\d{2}-\d{2}$/.test(t)) return t
  const m = t.match(/(\d+)周/)
  if (!m) return undefined
  const weeks = parseInt(m[1], 10)
  const d = new Date()
  d.setDate(d.getDate() + weeks * 7)
  return d.toISOString().slice(0, 10)
}
