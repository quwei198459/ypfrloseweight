package com.ypfr.loseweight;

import com.ypfr.loseweight.config.AliyunFoodProperties;
import com.ypfr.loseweight.config.JwtProperties;
import com.ypfr.loseweight.config.PhotoRecognitionProperties;
import com.ypfr.loseweight.config.SkinDetectionProperties;
import com.ypfr.loseweight.config.UploadProperties;
import com.ypfr.loseweight.config.WechatMiniappProperties;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@SpringBootApplication
@MapperScan("com.ypfr.loseweight.mapper")
@EnableConfigurationProperties({
  AliyunFoodProperties.class,
  WechatMiniappProperties.class,
  JwtProperties.class,
  UploadProperties.class,
  PhotoRecognitionProperties.class,
  SkinDetectionProperties.class
})
public class LoseweightApplication {

  public static void main(String[] args) {
    SpringApplication.run(LoseweightApplication.class, args);
  }
}
