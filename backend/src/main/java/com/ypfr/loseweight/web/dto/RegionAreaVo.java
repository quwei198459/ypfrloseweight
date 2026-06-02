package com.ypfr.loseweight.web.dto;

import java.util.ArrayList;
import java.util.List;

public class RegionAreaVo {

  private String code;
  private String name;
  private Integer level;
  private List<RegionAreaVo> children = new ArrayList<>();

  public String getCode() { return code; }
  public void setCode(String code) { this.code = code; }
  public String getName() { return name; }
  public void setName(String name) { this.name = name; }
  public Integer getLevel() { return level; }
  public void setLevel(Integer level) { this.level = level; }
  public List<RegionAreaVo> getChildren() { return children; }
  public void setChildren(List<RegionAreaVo> children) { this.children = children; }
}
