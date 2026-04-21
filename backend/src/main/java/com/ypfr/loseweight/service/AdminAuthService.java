package com.ypfr.loseweight.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ypfr.loseweight.common.ApiException;
import com.ypfr.loseweight.domain.AdminLoginLog;
import com.ypfr.loseweight.domain.AdminUser;
import com.ypfr.loseweight.mapper.AdminLoginLogMapper;
import com.ypfr.loseweight.mapper.AdminUserMapper;
import com.ypfr.loseweight.web.dto.admin.AdminLoginResponse;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AdminAuthService {

  private final AdminUserMapper adminUserMapper;
  private final AdminLoginLogMapper adminLoginLogMapper;
  private final AdminTokenService adminTokenService;
  private final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

  public AdminAuthService(
      AdminUserMapper adminUserMapper,
      AdminLoginLogMapper adminLoginLogMapper,
      AdminTokenService adminTokenService) {
    this.adminUserMapper = adminUserMapper;
    this.adminLoginLogMapper = adminLoginLogMapper;
    this.adminTokenService = adminTokenService;
  }

  public AdminLoginResponse login(String username, String password, String ip, String userAgent) {
    String normalizedUsername = username == null ? "" : username.trim();
    AdminUser admin =
        adminUserMapper.selectOne(
            new LambdaQueryWrapper<AdminUser>()
                .eq(AdminUser::getUsername, normalizedUsername)
                .last("LIMIT 1"));
    if (admin == null || admin.getStatus() == null || admin.getStatus() != 1) {
      saveLoginLog(null, normalizedUsername, 0, ip, userAgent);
      throw new ApiException(401, "用户名或密码错误");
    }
    if (!passwordEncoder.matches(password, admin.getPassword())) {
      saveLoginLog(admin.getId(), normalizedUsername, 0, ip, userAgent);
      throw new ApiException(401, "用户名或密码错误");
    }
    saveLoginLog(admin.getId(), normalizedUsername, 1, ip, userAgent);
    AdminLoginResponse resp = new AdminLoginResponse();
    resp.setUsername(admin.getUsername());
    resp.setToken(adminTokenService.createToken(admin.getId(), admin.getUsername()));
    resp.setExpireSeconds(adminTokenService.getExpireSeconds());
    return resp;
  }

  /** 当前登录管理员修改自己的登录密码 */
  public void changePassword(Long adminId, String oldPassword, String newPassword) {
    AdminUser admin = adminUserMapper.selectById(adminId);
    if (admin == null || admin.getStatus() == null || admin.getStatus() != 1) {
      throw new ApiException(400, "账号不存在或已禁用");
    }
    if (!passwordEncoder.matches(oldPassword, admin.getPassword())) {
      throw new ApiException(400, "原密码不正确");
    }
    if (oldPassword != null && newPassword != null && oldPassword.equals(newPassword)) {
      throw new ApiException(400, "新密码不能与当前密码相同");
    }
    admin.setPassword(passwordEncoder.encode(newPassword));
    adminUserMapper.updateById(admin);
  }

  private void saveLoginLog(Long adminId, String username, int success, String ip, String userAgent) {
    AdminLoginLog log = new AdminLoginLog();
    log.setAdminId(adminId);
    log.setUsername(username);
    log.setSuccess(success);
    log.setIp(ip);
    log.setUserAgent(userAgent);
    adminLoginLogMapper.insert(log);
  }
}
