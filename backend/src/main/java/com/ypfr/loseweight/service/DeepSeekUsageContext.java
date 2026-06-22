package com.ypfr.loseweight.service;

/**
 * 用 ThreadLocal 在一次请求线程内携带「触发 DeepSeek 调用的用户/业务记录」上下文，
 * 供 {@link DeepSeekUsageLogger} 落库时记录 userId / recordId，避免逐层改方法签名。
 *
 * <p>务必在业务入口处 set，并在 finally 中 clear，防止线程池复用造成串号。
 */
public final class DeepSeekUsageContext {

  public record Ctx(Long userId, Long recordId) {}

  private static final ThreadLocal<Ctx> HOLDER = new ThreadLocal<>();

  private DeepSeekUsageContext() {}

  public static void set(Long userId, Long recordId) {
    HOLDER.set(new Ctx(userId, recordId));
  }

  public static Ctx get() {
    return HOLDER.get();
  }

  public static void clear() {
    HOLDER.remove();
  }
}
