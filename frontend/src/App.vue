<template>
  <!--
    强制参与小程序分包编译，始终生成 components/PageTopHeader.wxml。
    避免 dev/HMR 或旧缓存仍引用该路径时出现 ENOENT。
    v-show="false" 保证组件不被 tree-shake，且界面不可见。
  -->
  <PageTopHeader v-show="false" title=" " :show-capsule="false" />
</template>

<script setup lang="ts">
import { onLaunch, onShow, onHide } from "@dcloudio/uni-app";
import PageTopHeader from "@/components/PageTopHeader.vue";
import { API_BASE_URL } from "@/config/api";

onLaunch(() => {
  console.log("App Launch");
  // 真机调试时请在 vConsole 核对：若不是电脑局域网 IP，说明未用到最新编译产物或未打开 dist/dev/mp-weixin
  console.log("[loseweight] API_BASE_URL =", API_BASE_URL);
});

onShow(() => {
  console.log("App Show");
});

onHide(() => {
  console.log("App Hide");
});
</script>

<style lang="scss">
page {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
  background-color: #ffffff;
  color: #333333;
}

page,
view {
  box-sizing: border-box;
}

view,
text,
input,
button {
  font-family: inherit;
}

button {
  border: none;
  background: none;
  padding: 0;
  margin: 0;
  cursor: pointer;
  outline: none;

  &:active {
    opacity: 0.8;
  }
}

input {
  border: none;
  outline: none;
  background: none;
  font-size: inherit;
  color: inherit;
}

/* 过小会导致与文案垂直方向视觉错位；各页可用 class 再微调 */
checkbox {
  width: 36rpx;
  height: 36rpx;
}
</style>

