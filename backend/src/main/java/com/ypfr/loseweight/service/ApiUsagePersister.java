package com.ypfr.loseweight.service;

import com.ypfr.loseweight.domain.ApiUsageLog;
import com.ypfr.loseweight.mapper.ApiUsageLogMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * 独立事务落库第三方接口用量：REQUIRES_NEW 保证即使外层业务事务回滚，已发生的调用流水仍保留，
 * 且其失败不影响主流程。
 */
@Service
public class ApiUsagePersister {

  private final ApiUsageLogMapper mapper;

  public ApiUsagePersister(ApiUsageLogMapper mapper) {
    this.mapper = mapper;
  }

  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void save(ApiUsageLog row) {
    mapper.insert(row);
  }
}
