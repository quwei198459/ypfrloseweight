package com.ypfr.loseweight.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.time.LocalDateTime;

/** 物理表 lw_user，对应 PRD user */
@TableName("lw_user")
public class LoseWeightUser {

  @TableId(type = IdType.AUTO)
  private Long id;

  private String openid;
  private String unionid;
  private String nickname;
  private String nicknameSource;
  private Integer nicknameAuthorized;
  private String avatar;
  private String avatarSource;
  private Integer avatarAuthorized;
  private String phone;
  private Integer phoneBindStatus;
  private LocalDateTime phoneBindTime;
  private String phoneSource;
  private Integer status;
  private String registerSource;
  private LocalDateTime createdAt;
  private LocalDateTime updatedAt;

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getOpenid() {
    return openid;
  }

  public void setOpenid(String openid) {
    this.openid = openid;
  }

  public String getUnionid() {
    return unionid;
  }

  public void setUnionid(String unionid) {
    this.unionid = unionid;
  }

  public String getNickname() {
    return nickname;
  }

  public void setNickname(String nickname) {
    this.nickname = nickname;
  }

  public String getNicknameSource() {
    return nicknameSource;
  }

  public void setNicknameSource(String nicknameSource) {
    this.nicknameSource = nicknameSource;
  }

  public Integer getNicknameAuthorized() {
    return nicknameAuthorized;
  }

  public void setNicknameAuthorized(Integer nicknameAuthorized) {
    this.nicknameAuthorized = nicknameAuthorized;
  }

  public String getAvatar() {
    return avatar;
  }

  public void setAvatar(String avatar) {
    this.avatar = avatar;
  }

  public String getAvatarSource() {
    return avatarSource;
  }

  public void setAvatarSource(String avatarSource) {
    this.avatarSource = avatarSource;
  }

  public Integer getAvatarAuthorized() {
    return avatarAuthorized;
  }

  public void setAvatarAuthorized(Integer avatarAuthorized) {
    this.avatarAuthorized = avatarAuthorized;
  }

  public String getPhone() {
    return phone;
  }

  public void setPhone(String phone) {
    this.phone = phone;
  }

  public Integer getPhoneBindStatus() {
    return phoneBindStatus;
  }

  public void setPhoneBindStatus(Integer phoneBindStatus) {
    this.phoneBindStatus = phoneBindStatus;
  }

  public LocalDateTime getPhoneBindTime() {
    return phoneBindTime;
  }

  public void setPhoneBindTime(LocalDateTime phoneBindTime) {
    this.phoneBindTime = phoneBindTime;
  }

  public String getPhoneSource() {
    return phoneSource;
  }

  public void setPhoneSource(String phoneSource) {
    this.phoneSource = phoneSource;
  }

  public Integer getStatus() {
    return status;
  }

  public void setStatus(Integer status) {
    this.status = status;
  }

  public String getRegisterSource() {
    return registerSource;
  }

  public void setRegisterSource(String registerSource) {
    this.registerSource = registerSource;
  }

  public LocalDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(LocalDateTime createdAt) {
    this.createdAt = createdAt;
  }

  public LocalDateTime getUpdatedAt() {
    return updatedAt;
  }

  public void setUpdatedAt(LocalDateTime updatedAt) {
    this.updatedAt = updatedAt;
  }
}
