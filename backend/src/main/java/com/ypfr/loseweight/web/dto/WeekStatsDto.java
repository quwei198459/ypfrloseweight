package com.ypfr.loseweight.web.dto;

import java.util.List;

public class WeekStatsDto {

  private List<WeekStatsCardDto> cards;

  public List<WeekStatsCardDto> getCards() {
    return cards;
  }

  public void setCards(List<WeekStatsCardDto> cards) {
    this.cards = cards;
  }
}
