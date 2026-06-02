package com.ypfr.loseweight.web;

import com.ypfr.loseweight.config.UploadProperties;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

/** 食物库缩略图：库内 image 存相对路径 /api/v1/public/food-images/{file} */
@RestController
public class PublicFoodImageController {

  private static final MediaType PNG = MediaType.IMAGE_PNG;

  private final UploadProperties uploadProperties;

  public PublicFoodImageController(UploadProperties uploadProperties) {
    this.uploadProperties = uploadProperties;
  }

  @GetMapping(value = "/api/v1/public/food-images/{fileName:.+}", produces = "image/png")
  public ResponseEntity<byte[]> foodImage(@PathVariable String fileName) {
    if (!fileName.matches("^(default|[0-9]+)\\.png$")) {
      return ResponseEntity.badRequest().build();
    }
    try {
      Path base = Paths.get(uploadProperties.getFoodImageDir()).toAbsolutePath().normalize();
      Path p = base.resolve(fileName).normalize();
      if (!p.startsWith(base) || !Files.exists(p) || !Files.isRegularFile(p)) {
        return ResponseEntity.notFound().build();
      }
      byte[] data = Files.readAllBytes(p);
      return ResponseEntity.ok().contentType(PNG).body(data);
    } catch (Exception e) {
      return ResponseEntity.notFound().build();
    }
  }
}
