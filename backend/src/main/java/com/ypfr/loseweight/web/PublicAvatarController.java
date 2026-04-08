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

@RestController
public class PublicAvatarController {

  private final UploadProperties uploadProperties;

  public PublicAvatarController(UploadProperties uploadProperties) {
    this.uploadProperties = uploadProperties;
  }

  @GetMapping(value = "/api/v1/public/avatars/{userId}", produces = MediaType.IMAGE_JPEG_VALUE)
  public ResponseEntity<byte[]> avatar(@PathVariable long userId) {
    try {
      Path p = Paths.get(uploadProperties.getAvatarDir()).resolve(userId + ".jpg");
      if (!Files.exists(p) || !Files.isRegularFile(p)) {
        return ResponseEntity.notFound().build();
      }
      byte[] data = Files.readAllBytes(p);
      return ResponseEntity.ok(data);
    } catch (Exception e) {
      return ResponseEntity.notFound().build();
    }
  }
}
