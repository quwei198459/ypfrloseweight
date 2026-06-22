package com.ypfr.loseweight.service;

import com.ypfr.loseweight.domain.DeepSeekUsageLog;
import com.ypfr.loseweight.mapper.DeepSeekUsageLogMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * 独立事务落库用量日志：用 REQUIRES_NEW 保证即使外层业务事务回滚，
 * 已发生（已计费）的 DeepSeek 调用记录仍然保留，且其失败不影响主流程。
 */
@Service
public class DeepSeekUsagePersister {

  private final DeepSeekUsageLogMapper mapper;

  public DeepSeekUsagePersister(DeepSeekUsageLogMapper mapper) {
    this.mapper = mapper;
  }

  @Transactional(propagation = Propagation.REQUIRES_NEW)
  public void save(DeepSeekUsageLog row) {
    mapper.insert(row);
  }
}
