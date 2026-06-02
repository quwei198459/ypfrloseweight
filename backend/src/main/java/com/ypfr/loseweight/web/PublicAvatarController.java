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
    return readFile(Paths.get(uploadProperties.getAvatarDir()).resolve(userId + ".jpg"));
  }

  @GetMapping(value = "/api/v1/public/avatars/photo-recognition/{fileName:.+}", produces = MediaType.IMAGE_PNG_VALUE)
  public ResponseEntity<byte[]> photoRecognitionAvatar(@PathVariable String fileName) {
    if (!fileName.matches("^service-qr\\.png$")) {
      return ResponseEntity.badRequest().build();
    }
    Path p = Paths.get(uploadProperties.getAvatarDir()).resolve("photo-recognition").resolve(fileName);
    return readFile(p);
  }

  private ResponseEntity<byte[]> readFile(Path p) {
    try {
      if (!Files.exists(p) || !Files.isRegularFile(p)) {
        return ResponseEntity.notFound().build();
      }
      byte[] data = Files.readAllBytes(p);
      MediaType type = p.getFileName().toString().endsWith(".png") ? MediaType.IMAGE_PNG : MediaType.IMAGE_JPEG;
      return ResponseEntity.ok().contentType(type).body(data);
    } catch (Exception e) {
      return ResponseEntity.notFound().build();
    }
  }
}
