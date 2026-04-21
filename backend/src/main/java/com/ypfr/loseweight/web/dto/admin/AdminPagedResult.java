package com.ypfr.loseweight.web.dto.admin;

import java.util.Collections;
import java.util.List;

public class AdminPagedResult<T> {

  private long total;
  private int page;
  private int pageSize;
  private List<T> list = Collections.emptyList();

  public long getTotal() {
    return total;
  }

  public void setTotal(long total) {
    this.total = total;
  }

  public int getPage() {
    return page;
  }

  public void setPage(int page) {
    this.page = page;
  }

  public int getPageSize() {
    return pageSize;
  }

  public void setPageSize(int pageSize) {
    this.pageSize = pageSize;
  }

  public List<T> getList() {
    return list;
  }

  public void setList(List<T> list) {
    this.list = list;
  }
}
