-- 资料是否已完善（登录后未完善则引导个人信息页）
USE loseweight;

ALTER TABLE app_user
  ADD COLUMN profile_completed TINYINT UNSIGNED NOT NULL DEFAULT 0
    COMMENT '1=资料已按规则完善，可进首页'
    AFTER phone;

-- 已有完整资料的老用户一次性标记为已完善
UPDATE app_user
SET profile_completed = 1
WHERE nickname IS NOT NULL
  AND TRIM(nickname) <> ''
  AND gender IN (1, 2)
  AND age IS NOT NULL AND age > 0
  AND height_cm IS NOT NULL AND height_cm > 0
  AND current_weight_kg IS NOT NULL AND current_weight_kg > 0
  AND target_weight_kg IS NOT NULL AND target_weight_kg > 0
  AND target_date IS NOT NULL;
