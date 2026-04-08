-- =============================================================================
-- V014（可选）: 验收通过后再执行。删除或仅归档 legacy 表。
-- 前置: 应用已切换新模型、且已完成数据对账
-- 警告: 执行后无法仅从库内恢复旧表结构数据（依赖备份回滚）
-- =============================================================================
--
-- 取消下面语句前的注释以执行：
--
-- USE loseweight;
-- SET FOREIGN_KEY_CHECKS = 0;
-- DROP TABLE IF EXISTS meal_record_legacy;
-- DROP TABLE IF EXISTS food_library_legacy;
-- DROP TABLE IF EXISTS sport_library_legacy;
-- SET FOREIGN_KEY_CHECKS = 1;
--
-- 若希望保留只读归档，可改为：
-- RENAME TABLE meal_record_legacy TO meal_record_archive_YYYYMMDD;
-- =============================================================================

SELECT 'V014: 默认不执行任何 DROP。请编辑本文件或手工执行上述注释块。' AS notice;
