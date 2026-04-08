<template>
  <scroll-view scroll-y class="page">
    <view class="bg-deco deco1" />
    <view class="bg-deco deco2" />
    <view class="hero">
      <view>
        <text class="title">GI值说明</text>
      </view>
      <text class="bear">ʕ•ᴥ•ʔ</text>
    </view>

    <view class="card">
      <view class="rod top" />
      <view class="content">
        <text class="h2">什么是GI值</text>
        <text class="p">GI值（升糖指数）是衡量食物引起血糖上升速度和幅度的指标。GI越高，血糖上升越快；GI越低，血糖上升越平稳。</text>

        <text class="h2">GI值如何划分高中低</text>
        <text class="p">低GI：GI值&lt;55，升糖速度慢，更适合减脂期稳定能量与饱腹感。</text>
        <text class="p">中GI：55≤GI值≤70，升糖速度中等，建议搭配蛋白质和蔬菜食用。</text>
        <text class="p">高GI：GI值&gt;70，升糖速度快，建议控制频率与总量。</text>

        <text class="h2">哪些食物为低GI</text>
        <text class="sub">谷物和谷类产品</text>
        <text class="p">燕麦、荞麦、藜麦、全麦面包（无添加糖）等。</text>
        <text class="sub">蔬菜和水果</text>
        <text class="p">西兰花、黄瓜、番茄、苹果、梨、柚子、草莓等。</text>
        <text class="sub">牛奶制品</text>
        <text class="p">无糖酸奶、纯牛奶、低糖奶酪等。</text>
        <text class="sub">豆类及其制品</text>
        <text class="p">黄豆、黑豆、鹰嘴豆、豆腐、无糖豆浆等。</text>
        <text class="sub">肉类、鱼类和蛋类</text>
        <text class="p">鸡胸肉、牛肉、鱼虾、鸡蛋等，几乎不直接造成明显升糖。</text>
        <text class="sub">坚果和种子</text>
        <text class="p">杏仁、核桃、巴旦木、亚麻籽、奇亚籽等，建议适量食用。</text>
      </view>
      <view class="rod bottom" />
    </view>
  </scroll-view>
</template>

<style scoped lang="scss">
.page { height: 100vh; background: #eaf2d6; padding: 16px; box-sizing: border-box; position: relative; }
.bg-deco { position: absolute; border-radius: 50%; opacity: .25; }
.deco1 { width: 140px; height: 140px; background: #c9dca0; right: -30px; top: 110px; }
.deco2 { width: 90px; height: 90px; background: #dce9be; left: -24px; top: 300px; }
.hero { margin-top: 8px; display: flex; align-items: center; justify-content: space-between; position: relative; z-index: 1; }
.title { font-size: 32px; font-weight: 700; color: #3d4d2e; }
.bear { font-size: 34px; }
.card {
  margin-top: 14px; border-radius: 16px; background: #fff; border: 1px solid #3e4a2d;
  overflow: hidden; position: relative; z-index: 1;
}
.rod { height: 14px; background: #bfd98a; border-bottom: 1px solid #81965d; }
.rod.bottom { border-bottom: 0; border-top: 1px solid #81965d; }
.content { padding: 14px 14px 26px; display: flex; flex-direction: column; gap: 8px; }
.h2 { margin-top: 8px; font-size: 16px; font-weight: 700; color: #2e3a1f; }
.sub { margin-top: 4px; font-size: 14px; font-weight: 600; color: #4a5a2e; }
.p { font-size: 13px; color: #4d4d4d; line-height: 1.65; }
</style>

