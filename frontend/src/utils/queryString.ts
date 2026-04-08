/**
 * 构建 URL 查询串（微信小程序等运行环境无全局 URLSearchParams）。
 */
export function toQueryString(params: Record<string, string | undefined | null>): string {
  const parts: string[] = []
  for (const key of Object.keys(params)) {
    const v = params[key]
    if (v === undefined || v === null || v === '') continue
    parts.push(`${encodeURIComponent(key)}=${encodeURIComponent(v)}`)
  }
  return parts.join('&')
}
