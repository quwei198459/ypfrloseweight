import type { DailyRecordDto } from '@/api/types'

/** 后端当前与 DailyRecordDto 一致；PRD 字段差异时在此映射 */
export function mapToDailyRecordDto(raw: DailyRecordDto): DailyRecordDto {
  return raw
}
