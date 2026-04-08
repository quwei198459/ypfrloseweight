package com.ypfr.loseweight.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.upload")
public class UploadProperties {

  /** 用户头像文件目录（相对运行目录或绝对路径） */
  private String avatarDir = "./uploads/avatars";

  public String getAvatarDir() {
    return avatarDir;
  }

  public void setAvatarDir(String avatarDir) {
    this.avatarDir = avatarDir;
  }
}
