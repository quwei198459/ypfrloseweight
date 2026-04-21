import { defineConfig, loadEnv } from "vite";
import uni from "@dcloudio/vite-plugin-uni";

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => {
  /** 与 package.json 中 scripts 的工作目录一致：请在 frontend 根目录执行 npm run dev:mp-weixin */
  const root = ".";
  const primary = loadEnv(mode, root, "VITE_");
  /** 部分 uni 构建场景下 mode 不是 development，导致未加载 .env.development，真机仍走 api.ts 里 127 默认值 */
  const merged =
    mode === "production"
      ? primary
      : { ...loadEnv("development", root, "VITE_"), ...primary };
  const apiBase = (merged.VITE_API_BASE_URL || "").replace(/\/$/, "");

  return {
    plugins: [uni()],
    define: apiBase
      ? { "import.meta.env.VITE_API_BASE_URL": JSON.stringify(apiBase) }
      : {},
  };
});
