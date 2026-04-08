-- 微信手机号绑定（getPhoneNumber 新版 code 换号后写入）
USE loseweight;

ALTER TABLE app_user
  ADD COLUMN phone VARCHAR(20) DEFAULT NULL COMMENT '微信授权手机号（纯数字，含区号场景见微信文档）' AFTER avatar_url;
