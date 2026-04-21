package com.ypfr.loseweight.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.upload")
public class UploadProperties {

  /** 用户头像文件目录（相对运行目录或绝对路径） */
  private String avatarDir = "./uploads/avatars";

  /** 食物缩略图（default.png、{foodId}.png），由 GET /api/v1/public/food-images/... 读取 */
  private String foodImageDir = "./uploads/food-images";

  public String getAvatarDir() {
    return avatarDir;
  }

  public void setAvatarDir(String avatarDir) {
    this.avatarDir = avatarDir;
  }

  public String getFoodImageDir() {
    return foodImageDir;
  }

  public void setFoodImageDir(String foodImageDir) {
    this.foodImageDir = foodImageDir;
  }
}
