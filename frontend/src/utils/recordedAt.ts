import { formatLocalDate } from '@/utils/date'

/** 后端 RecordedAtParser 可解析的本地时间（无时区后缀） */
export function formatRecordedAtNow(): string {
  const d = new Date()
  const p = (n: number) => String(n).padStart(2, '0')
  return `${d.getFullYear()}-${p(d.getMonth() + 1)}-${p(d.getDate())}T${p(d.getHours())}:${p(d.getMinutes())}:${p(d.getSeconds())}`
}

/** 与后端 createBatch 默认时间规则对齐：当日用此刻，历史日用当天 12:00 */
export function formatRecordedAtForYmd(ymd: string): string {
  const today = formatLocalDate(new Date())
  if (ymd === today) {
    return formatRecordedAtNow()
  }
  return `${ymd}T12:00:00`
}
