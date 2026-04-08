下面是我为你合并整理后的**减脂微信小程序完整终版 PRD**。
这版已经把你前面补充的所有关键内容统一合并进去了，包括：

* 微信登录 / openid
* 默认头像 / 随机昵称
* 头像、昵称、手机号在个人信息页分别获取
* 普通用户可用拍照识图
* 阿里云食物图片热量识别接入
* 饮食记录、餐次模型、运动记录、趋势、周报
* 计划页、VIP页
* 数据库模型
* 接口清单
* 核心业务逻辑
* 后端实现建议

你可以直接把这份作为开发主 PRD 使用。

---

# 减脂微信小程序完整终版 PRD

---

# 一、产品概述

## 1.1 产品名称

吃多少

## 1.2 产品定位

这是一款以“减脂目标管理”为核心的微信小程序。
核心价值不是单纯记录饮食，而是帮助用户围绕减脂目标完成完整闭环：

* 建立减脂档案
* 生成每日热量预算
* 记录饮食
* 记录运动
* 记录体重
* 输出单次饮食评价
* 输出每日和每周复盘
* 给出计划引导与阶段性反馈

---

## 1.3 产品目标

为用户提供一个低门槛、可执行、可复盘的减脂管理工具，让用户形成如下链路：

登录 → 建档 → 生成预算 → 每日饮食/运动记录 → 趋势复盘 → 周统计反馈 → 持续减脂执行

---

## 1.4 核心用户

* 有减脂需求的普通用户
* 希望通过记录饮食、运动、体重进行科学控制的人群
* 希望通过拍照识图快速记录食物的人群

---

# 二、核心业务闭环

## 2.1 闭环一：用户身份建立

微信登录 → 获取 openid → 创建系统用户 → 分配默认头像与随机昵称

---

## 2.2 闭环二：减脂档案建立

进入个人信息页 → 获取头像/昵称/手机号 → 填写性别、年龄、身高、体重、目标体重、目标达成时间 → 生成预算

---

## 2.3 闭环三：每日减脂执行

首页 → 早餐/午餐/晚餐/加餐/运动 → 记录后更新今日摄入、运动、还可吃 → 输出当日数据变化

---

## 2.4 闭环四：饮食快速录入

支持四种录入方式：

* 分类选品录入
* 搜索热量录入
* 自定义食物录入
* 餐前拍一拍识图录入

---

## 2.5 闭环五：复盘反馈

* 单次饮食评价结果
* 每日饮食记录页
* 减脂趋势页
* 本周数据统计页

---

# 三、核心公式与业务口径

## 3.1 今日还可吃

`今日还可吃 = 每日预算 - 今日饮食摄入 + 今日运动消耗`

---

## 3.2 每日预算

`每日预算 = TDEE - 每日推荐热量缺口`

---

## 3.3 总消耗

`TDEE = BMR × 活动系数`

---

## 3.4 基础代谢 BMR

男：
`BMR = 10*体重kg + 6.25*身高cm - 5*年龄 + 5`

女：
`BMR = 10*体重kg + 6.25*身高cm - 5*年龄 - 161`

---

## 3.5 每日推荐缺口

* 待减体重 = 当前体重 - 目标体重
* 总热量差 = 待减kg × 7700
* 每日缺口 = 总热量差 ÷ 距目标日期天数

---

## 3.6 运动消耗

`caloriesBurned = caloriesPer60Min × durationMin / 60`

---

## 3.7 宏营养素目标

默认减脂推荐口径：

* 碳水 50%
* 蛋白 20%
* 脂肪 30%

换算公式：

* carb = calorie × 50% ÷ 4
* protein = calorie × 20% ÷ 4
* fat = calorie × 30% ÷ 9

---

## 3.8 周统计口径建议

### 实际热量缺口

`actualDeficit = TDEE + exercise - intake`

### 预算缺口

`budgetDeficit = dailyBudget - intake + exercise`

建议：
后端同时保留两个口径，前端主展示统一使用一个口径。
推荐前端主展示使用：**实际热量缺口**

---

# 四、登录与用户体系

## 4.1 登录方式

使用微信登录。

前端通过 `wx.login` 获取 `code`，后端通过 `code` 换取 `openid`，建立系统用户身份。

---

## 4.2 登录阶段目标

登录阶段只完成以下动作：

* 获取微信 code
* 换取 openid
* 创建或查找用户
* 返回业务 token

登录阶段**不强制获取**：

* 微信头像
* 微信昵称
* 微信手机号

---

## 4.3 首次登录初始化规则

首次登录用户若不存在，则自动创建用户，并初始化：

* 默认头像
* 随机昵称
* 手机号为空
* 用户状态正常

---

## 4.4 默认头像规则

如果用户未获取微信头像，系统使用默认头像占位图。

---

## 4.5 随机昵称规则

系统自动生成随机昵称：

格式：
`想瘦的 + 4位随机数`

例如：

* 想瘦的3508
* 想瘦的4821
* 想瘦的1276

---

## 4.6 用户资料获取策略

头像、昵称、手机号统一放到【个人信息编辑页】中，分开分别获取：

* 点击头像：单独获取头像
* 点击昵称：单独获取昵称
* 点击手机号授权按钮：单独获取手机号

---

# 五、页面结构总览

整套小程序主要页面如下：

1. 登录页
2. 首页
3. 饮食选品页
4. 食物营养详情弹窗
5. 自定义食物弹窗
6. 每日饮食记录页
7. 本次饮食评价结果页
8. 运动项目页
9. 运动记录弹窗
10. 自定义运动弹窗
11. 热量查询页
12. 餐前拍一拍页
13. 识别结果确认页 / 识别结果态
14. 我的页
15. 个人信息页
16. 减脂趋势页
17. 当前体重记录弹窗
18. 本周数据统计页
19. 专属计划生成页
20. VIP 开通页

---

# 六、页面级 PRD

---

# 6.1 登录页

## 页面目标

完成微信登录并建立用户身份。

## 页面展示

* 产品 logo
* 产品名
* slogan
* 微信登录按钮
* 用户协议 / 隐私协议勾选区

## 核心交互

点击“微信登录”：

1. 前端调用 `wx.login`
2. 获取 `code`
3. 调用后端登录接口
4. 后端返回 token、用户基础信息
5. 登录成功进入首页

## 逻辑

* 若首次登录，则初始化默认头像与随机昵称
* 若非首次登录，直接返回用户当前资料

---

# 6.2 首页

## 页面目标

给用户一个“今日减脂执行总览面板”。

## 页面展示

* 顶部产品区
* 搜索框
* 相机入口
* 今日饮食摄入
* 今日运动消耗
* 今日还可吃
* 早餐/午餐/晚餐/加餐/运动快捷入口
* 营销引导卡
* 底部 tab

## 字段

* date
* intakeCalories
* exerciseCalories
* remainCalories
* dailyBudgetCalories
* mealStatus
* marketingCards

## 核心交互

* 点击早餐/午餐/晚餐/加餐 → 饮食选品页
* 点击运动 → 运动项目页
* 点击搜索 → 热量查询页
* 点击相机 → 餐前拍一拍页
* 点击仪表盘 / 还可吃 → 每日饮食记录页
* 点击引导卡 → 专属计划页或 VIP 页
* 点击底部“我的” → 我的页

## 逻辑

* 页面加载时请求今日总览接口
* 若减脂档案未完善，可轻提示用户完善资料

---

# 6.3 饮食选品页

## 页面目标

帮助用户按餐别快速选食物并形成一餐。

## 页面展示

* 日期标题
* 搜索框
* 新增按钮
* 左侧分类栏
* 右侧食物列表
* 底部已选统计区
* 完成按钮

## 分类展示

* 常用
* 早餐
* 荤菜
* 素菜
* 品牌/场景分类等

## 食物项字段

* foodId
* foodName
* image
* giLevel
* calories
* caloriesUnitDesc
* standardWeightG
* isSelected
* selectedAmount
* selectedCalories

## 底部统计区字段

* mealType
* selectedCount
* selectedCalories

## 核心交互

* 点击分类，切换右侧食物列表
* 点击食物 +，进入数量录入弹层
* 已选食物展示对勾态
* 点击新增，打开自定义食物弹窗
* 点击完成，提交当前餐次

## 核心逻辑

这里必须使用“餐次模型”。

### 正确链路

1. 用户进入饮食选品页
2. 多个食物加入临时选中态
3. 底部实时累计条数和热量
4. 点击完成
5. 才正式创建餐次并落明细记录

---

# 6.4 食物营养详情弹窗

## 页面目标

让用户输入数量/重量，确认加入当前餐次。

## 页面展示

* 食物名称
* GI 标签
* 热量
* 碳水/蛋白/脂肪
* 可食部
* 估重入口
* 输入区
* 数字键盘
* 确定按钮

## 字段

* foodId
* foodName
* caloriesPer100g
* caloriesPerUnit
* carbPer100g
* proteinPer100g
* fatPer100g
* ediblePortionRate
* inputAmount
* amountUnit
* totalCalories
* totalCarb
* totalProtein
* totalFat

## 交互

* 输入克数 / 个数 / 份数
* 点击确定加入当前临时餐次
* 返回饮食选品页

## 逻辑

如果是按 100g：
`总热量 = caloriesPer100g × 输入克数 / 100`

如果是按单位：
`总热量 = caloriesPerUnit × 数量`

---

# 6.5 自定义食物弹窗

## 页面目标

允许用户新增系统库没有的食物。

## 字段

* customFoodName
* weightG
* calories
* mealType
* date

## 交互

* 名称必填
* 重量必填
* 热量选填
* 确定后加入当前餐次

## 逻辑

* 创建用户私有食物
* 同时加入当前临时餐次
* 后续可出现在常用/我的食物中

---

# 6.6 每日饮食记录页

## 页面目标

按天查看饮食与运动完整执行结果。

## 页面展示

* 日期选择区
* 日状态标识（无效/正常/吃多了）
* 汇总卡片
* 宏量营养条
* 时间线
* 底部快捷录入入口

## 汇总字段

* date
* remainCalories
* dailyBudgetCalories
* intakeCalories
* exerciseCalories
* carbConsumed / carbTarget
* fatConsumed / fatTarget
* proteinConsumed / proteinTarget
* dayStatus

## 时间线字段

每条记录包含：

* recordType
* recordTime
* title
* subTitle
* summary
* details

### 餐次记录

* mealType
* totalCalories
* foodItems[]

### 运动记录

* sportName
* duration
* caloriesBurned

## 核心交互

* 切换日期
* 查看当天时间线
* 点击底部早餐/午餐/晚餐/加餐 → 继续录入
* 点击运动 → 运动项目页

## 逻辑

* 前端只渲染，后端返回完整 recordList
* 完成某餐后可自动跳转饮食评价页

---

# 6.7 本次饮食评价结果页

## 页面目标

对本次饮食进行即时评价与建议输出。

## 页面展示

* 评价等级（优秀/良好/欠佳）
* 总热量
* 三大营养素占比
* 营养师评语
* 优点
* 缺点
* 下一顿建议
* 确定按钮

## 字段

* mealScoreLevel
* mealCalories
* carbGram / percent
* proteinGram / percent
* fatGram / percent
* advantages
* disadvantages
* nextMealSuggestion

## 触发时机

完成一餐提交后自动触发。

## 规则

v1 使用规则引擎，不依赖 AI。

---

# 6.8 运动项目页

## 页面目标

供用户选择运动项目并记录时长。

## 页面展示

* 搜索框
* 新增按钮
* 运动列表
* 每60分钟消耗

## 字段

* sportItemId
* sportName
* icon
* caloriesPer60Min
* category
* isCustom

## 核心交互

* 点击运动项 → 运动记录弹窗
* 点击新增 → 自定义运动弹窗

---

# 6.9 运动记录弹窗

## 页面目标

记录一次运动。

## 字段

* sportItemId
* sportName
* durationMin
* caloriesPer60Min
* caloriesBurned

## 逻辑

`caloriesBurned = caloriesPer60Min × durationMin / 60`

---

# 6.10 自定义运动弹窗

## 页面目标

录入系统库没有的运动。

## 字段

* customSportName
* durationMin
* caloriesBurned

## 逻辑

* 名称必填
* 时长必填
* 消耗选填
* 确认后生成私有运动项并写入当次记录

---

# 6.11 热量查询页

## 页面目标

独立搜索食物热量信息。

## 页面展示

* 搜索框
* 相机图标
* 搜索结果列表
* GI 标签

## 结果字段

* foodName
* image
* caloriesPer100g
* giLevel

## 交互

* 输入关键词实时搜索
* 点击结果查看详情
* 点击相机进入餐前拍一拍页

---

# 6.12 餐前拍一拍页

## 页面目标

通过拍照或相册识别食物，辅助录入饮食。

## 页面展示

* 标题
* 图片预览区
* 上传中 / 识别中 loading
* 相册按钮
* 拍照按钮
* 引导文案

## 图片来源

* camera
* album

## 页面状态

* 初始态
* 已选图上传中
* 识别成功
* 识别失败

## 权限规则

* 普通用户可用
* VIP 用户可用
* 非 VIP 不拦截

---

# 6.13 识别结果确认页 / 识别结果态

## 页面目标

承接阿里云识别结果，供用户确认。

## 页面展示

* 原图缩略图
* 候选食物列表
* 热量信息
* 份量估算
* 勾选/取消
* 确认加入当前餐次

## 逻辑

* 若识别返回多个候选，用户手动确认
* 若识别结果模糊，则跳转热量查询页自动带关键词
* 用户确认后，进入正式餐次写入

---

# 6.14 我的页

## 页面目标

展示用户减脂摘要和重要入口。

## 页面展示

* 头像
* 昵称
* 加入天数
* 饮食记录次数
* 健康饮食天数
* 最近7天热量缺口
* 当前体重
* 数据统计入口
* 趋势入口
* 计划入口

## 核心交互

* 点击头像编辑 → 个人信息页
* 点击统计 → 本周数据统计页
* 点击当前体重 → 减脂趋势页
* 点击计划 → 专属计划页 / VIP 页

---

# 6.15 个人信息页

## 页面目标

维护用户资料与减脂档案，并承接微信资料获取。

## 页面结构

### 头像昵称区

* 我的头像
* 我的昵称

### 手机号区

* 手机号
* 微信授权手机号按钮

### 减脂档案区

* 性别
* 年龄
* 身高
* 最新体重
* 目标体重
* 目标达成时间

### 保存区

* 保存个人信息按钮

## 逻辑

* 点击头像：单独获取头像
* 点击昵称：单独获取昵称
* 点击手机号按钮：单独获取手机号
* 点击保存：保存减脂档案并触发预算重算

## 预算影响字段

只有以下字段影响预算：

* 性别
* 年龄
* 身高
* 当前体重
* 目标体重
* 目标达成时间

头像、昵称、手机号不影响预算。

---

# 6.16 减脂趋势页

## 页面目标

展示减脂趋势和体重变化。

## 页面展示

* 累计减重
* 初始体重
* 当前体重
* 目标体重
* 体重趋势图
* +记录体重按钮

## 逻辑

* 支持编辑初始体重、当前体重、目标体重
* 支持新增体重记录
* 若累计减重小于 0，v1 可展示 0

---

# 6.17 当前体重记录弹窗

## 页面目标

让用户录入或修改当前体重。

## 展示

* 斤 / 公斤切换
* 数字输入框
* 确定 / 取消

---

# 6.18 本周数据统计页

## 页面目标

展示某周减脂执行结果。

## 页面展示

* 周区间
* 日均热量缺口
* 日均饮食摄入
* 日运动消耗
* 日均轻断食用餐时长
* 推荐线

## 图表结构

统一返回：

* summaryValue
* recommendationValue
* xAxis
* series

---

# 6.19 专属计划生成页

## 页面目标

承接减脂计划引导与计划激活。

## 页面展示

* 计划总周期
* 预计减重
* 成功率文案
* 阶段图
* 动态计划说明
* 热量缺口建议
* 运动建议
* 饮食节奏建议
* 开始使用按钮

## 交互

点击“开始使用专属计划”：

* 激活计划
* 写入 user_plan

---

# 6.20 VIP 开通页

## 页面目标

承载会员商业化。

## 页面展示

* 套餐选择
* 价格
* 权益列表
* 购买按钮
* 协议勾选

## 权益方向

* 更高识别额度
* 更完整计划
* 更高级营养建议
* 更长识别历史保存
* 食谱推荐增强

注意：
**拍照识图不是 VIP 独占能力。**

---

# 七、餐次模型设计

这是本项目最关键的模型修正点。

## 7.1 问题

如果只有 diet_record 单条食物记录，会导致“一餐多食物”难以统一评价和提交。

## 7.2 正确方案

必须拆成：

### meal_record：餐次表

一顿饭一条主记录

### diet_record：食物明细表

一顿饭下面多个食物明细

---

# 八、数据库模型

---

## 8.1 用户表 user

| 字段                  | 类型       | 说明                                   |
| ------------------- | -------- | ------------------------------------ |
| id                  | bigint   | 主键                                   |
| openid              | varchar  | 微信openid                             |
| unionid             | varchar  | 预留                                   |
| nickname            | varchar  | 当前昵称                                 |
| nickname_source     | varchar  | system_default / wx_profile / manual |
| nickname_authorized | tinyint  | 是否已获取微信昵称                            |
| avatar              | varchar  | 当前头像                                 |
| avatar_source       | varchar  | system_default / wx_profile / manual |
| avatar_authorized   | tinyint  | 是否已获取微信头像                            |
| phone               | varchar  | 手机号                                  |
| phone_bind_status   | tinyint  | 是否绑定                                 |
| phone_bind_time     | datetime | 绑定时间                                 |
| phone_source        | varchar  | wx_phone                             |
| status              | tinyint  | 状态                                   |
| register_source     | varchar  | 注册来源                                 |
| created_at          | datetime | 创建时间                                 |
| updated_at          | datetime | 更新时间                                 |

---

## 8.2 用户减脂档案表 user_profile

| 字段                | 类型       | 说明     |
| ----------------- | -------- | ------ |
| id                | bigint   | 主键     |
| user_id           | bigint   | 用户ID   |
| gender            | tinyint  | 性别     |
| age               | int      | 年龄     |
| height_cm         | decimal  | 身高     |
| initial_weight_kg | decimal  | 初始体重kg |
| current_weight_kg | decimal  | 当前体重kg |
| target_weight_kg  | decimal  | 目标体重kg |
| target_date       | date     | 目标日期   |
| profile_completed | tinyint  | 是否完善   |
| created_at        | datetime | 创建时间   |
| updated_at        | datetime | 更新时间   |

---

## 8.3 用户预算配置表 user_budget_config

| 字段                  | 类型       | 说明       |
| ------------------- | -------- | -------- |
| id                  | bigint   | 主键       |
| user_id             | bigint   | 用户ID     |
| use_custom_bmr      | tinyint  | 是否自定义BMR |
| custom_bmr          | decimal  | 自定义基础代谢  |
| activity_level      | decimal  | 活动系数     |
| calculated_bmr      | decimal  | 系统计算BMR  |
| calculated_tdee     | decimal  | 系统计算TDEE |
| recommended_deficit | decimal  | 推荐缺口     |
| daily_budget        | decimal  | 每日预算     |
| carb_target_g       | decimal  | 碳水目标     |
| protein_target_g    | decimal  | 蛋白目标     |
| fat_target_g        | decimal  | 脂肪目标     |
| effective_date      | date     | 生效日期     |
| created_at          | datetime | 创建时间     |
| updated_at          | datetime | 更新时间     |

---

## 8.4 体重记录表 user_weight_record

| 字段          | 类型       | 说明            |
| ----------- | -------- | ------------- |
| id          | bigint   | 主键            |
| user_id     | bigint   | 用户ID          |
| record_date | date     | 记录日期          |
| weight_kg   | decimal  | 体重kg          |
| source      | varchar  | manual/system |
| remark      | varchar  | 备注            |
| created_at  | datetime | 创建时间          |

---

## 8.5 食物分类表 food_category

| 字段        | 类型      | 说明                         |
| --------- | ------- | -------------------------- |
| id        | bigint  | 主键                         |
| name      | varchar | 分类名                        |
| parent_id | bigint  | 父分类                        |
| type      | varchar | system/brand/common/custom |
| sort_no   | int     | 排序                         |
| status    | tinyint | 状态                         |

---

## 8.6 食物表 food

| 字段                  | 类型       | 说明           |
| ------------------- | -------- | ------------ |
| id                  | bigint   | 主键           |
| creator_user_id     | bigint   | 创建人          |
| category_id         | bigint   | 分类           |
| name                | varchar  | 名称           |
| image               | varchar  | 图片           |
| gi_level            | varchar  | low/mid/high |
| calories_per_100g   | decimal  | 每100g热量      |
| calories_per_unit   | decimal  | 每单位热量        |
| unit_name           | varchar  | 个/杯/碗/根      |
| standard_weight_g   | decimal  | 单位重量         |
| edible_portion_rate | decimal  | 可食部率         |
| carb_per_100g       | decimal  | 碳水           |
| protein_per_100g    | decimal  | 蛋白           |
| fat_per_100g        | decimal  | 脂肪           |
| keywords            | varchar  | 搜索词          |
| is_custom           | tinyint  | 是否自定义        |
| status              | tinyint  | 状态           |
| created_at          | datetime | 创建时间         |
| updated_at          | datetime | 更新时间         |

---

## 8.7 餐次表 meal_record

| 字段              | 类型       | 说明                           |
| --------------- | -------- | ---------------------------- |
| id              | bigint   | 主键                           |
| user_id         | bigint   | 用户ID                         |
| record_date     | date     | 日期                           |
| meal_type       | varchar  | breakfast/lunch/dinner/snack |
| total_calories  | decimal  | 本餐总热量                        |
| total_carb_g    | decimal  | 碳水总量                         |
| total_protein_g | decimal  | 蛋白总量                         |
| total_fat_g     | decimal  | 脂肪总量                         |
| food_count      | int      | 食物条数                         |
| status          | varchar  | draft/submitted              |
| created_at      | datetime | 创建时间                         |
| updated_at      | datetime | 更新时间                         |

---

## 8.8 饮食明细表 diet_record

| 字段                 | 类型       | 说明                         |
| ------------------ | -------- | -------------------------- |
| id                 | bigint   | 主键                         |
| meal_id            | bigint   | 餐次ID                       |
| user_id            | bigint   | 用户ID                       |
| record_date        | date     | 日期                         |
| meal_type          | varchar  | 餐别                         |
| food_id            | bigint   | 食物ID                       |
| food_name_snapshot | varchar  | 名称快照                       |
| image_snapshot     | varchar  | 图片快照                       |
| gi_level_snapshot  | varchar  | GI快照                       |
| amount             | decimal  | 数量                         |
| amount_unit        | varchar  | 单位                         |
| weight_g           | decimal  | 重量g                        |
| calories_total     | decimal  | 总热量                        |
| carb_total_g       | decimal  | 碳水                         |
| protein_total_g    | decimal  | 蛋白                         |
| fat_total_g        | decimal  | 脂肪                         |
| source             | varchar  | search/custom/photo/manual |
| record_time        | datetime | 记录时间                       |
| created_at         | datetime | 创建时间                       |
| updated_at         | datetime | 更新时间                       |

---

## 8.9 运动项目表 sport_item

| 字段                 | 类型       | 说明      |
| ------------------ | -------- | ------- |
| id                 | bigint   | 主键      |
| creator_user_id    | bigint   | 创建人     |
| name               | varchar  | 名称      |
| icon               | varchar  | 图标      |
| calories_per_60min | decimal  | 每60分钟消耗 |
| category           | varchar  | 分类      |
| is_custom          | tinyint  | 是否自定义   |
| status             | tinyint  | 状态      |
| sort_no            | int      | 排序      |
| created_at         | datetime | 创建时间    |
| updated_at         | datetime | 更新时间    |

---

## 8.10 运动记录表 sport_record

| 字段                  | 类型       | 说明                   |
| ------------------- | -------- | -------------------- |
| id                  | bigint   | 主键                   |
| user_id             | bigint   | 用户ID                 |
| record_date         | date     | 日期                   |
| sport_item_id       | bigint   | 项目ID                 |
| sport_name_snapshot | varchar  | 名称快照                 |
| icon_snapshot       | varchar  | 图标快照                 |
| duration_min        | int      | 时长分钟                 |
| calories_burned     | decimal  | 消耗                   |
| source              | varchar  | system/custom/manual |
| record_time         | datetime | 记录时间                 |
| created_at          | datetime | 创建时间                 |
| updated_at          | datetime | 更新时间                 |

---

## 8.11 每日汇总表 daily_summary

| 字段                      | 类型       | 说明                     |
| ----------------------- | -------- | ---------------------- |
| id                      | bigint   | 主键                     |
| user_id                 | bigint   | 用户ID                   |
| summary_date            | date     | 日期                     |
| daily_budget            | decimal  | 当日预算                   |
| intake_calories         | decimal  | 饮食摄入                   |
| exercise_calories       | decimal  | 运动消耗                   |
| remain_calories         | decimal  | 还可吃                    |
| actual_deficit_calories | decimal  | 实际缺口                   |
| budget_deficit_calories | decimal  | 预算缺口                   |
| carb_total_g            | decimal  | 碳水摄入                   |
| protein_total_g         | decimal  | 蛋白摄入                   |
| fat_total_g             | decimal  | 脂肪摄入                   |
| carb_target_g           | decimal  | 碳水目标                   |
| protein_target_g        | decimal  | 蛋白目标                   |
| fat_target_g            | decimal  | 脂肪目标                   |
| first_meal_time         | datetime | 首餐时间                   |
| last_meal_time          | datetime | 末餐时间                   |
| eating_window_hours     | decimal  | 进食时长                   |
| healthy_diet_flag       | tinyint  | 健康饮食日                  |
| day_status              | varchar  | normal/overeat/invalid |
| created_at              | datetime | 创建时间                   |
| updated_at              | datetime | 更新时间                   |

---

## 8.12 饮食评价表 meal_evaluation

| 字段                | 类型       | 说明       |
| ----------------- | -------- | -------- |
| id                | bigint   | 主键       |
| user_id           | bigint   | 用户ID     |
| meal_id           | bigint   | 餐次ID     |
| record_date       | date     | 日期       |
| meal_type         | varchar  | 餐别       |
| total_calories    | decimal  | 热量       |
| score_level       | varchar  | 优秀/良好/欠佳 |
| advantage_text    | text     | 优点       |
| disadvantage_text | text     | 缺点       |
| suggestion_text   | text     | 下一顿建议    |
| created_at        | datetime | 创建时间     |

---

## 8.13 图片识别记录表 meal_photo_recognition

| 字段                 | 类型       | 说明                                  |
| ------------------ | -------- | ----------------------------------- |
| id                 | bigint   | 主键                                  |
| user_id            | bigint   | 用户ID                                |
| meal_type          | varchar  | 当前识别餐别                              |
| record_date        | date     | 日期                                  |
| source             | varchar  | camera/album                        |
| image_url          | varchar  | 图片地址                                |
| recognize_status   | varchar  | uploading/recognizing/success/fail  |
| vendor             | varchar  | aliyun                              |
| vendor_request_id  | varchar  | 第三方请求ID                             |
| raw_result         | text     | 原始返回                                |
| parsed_result_json | text     | 解析结果                                |
| result_type        | varchar  | candidate_foods/keyword_only/failed |
| error_code         | varchar  | 错误码                                 |
| error_message      | varchar  | 错误信息                                |
| created_at         | datetime | 创建时间                                |
| updated_at         | datetime | 更新时间                                |

---

## 8.14 用户计划表 user_plan

| 字段                    | 类型       | 说明     |
| --------------------- | -------- | ------ |
| id                    | bigint   | 主键     |
| user_id               | bigint   | 用户ID   |
| total_weeks           | int      | 周期     |
| target_weight_loss_kg | decimal  | 目标减重   |
| daily_deficit_target  | decimal  | 每日缺口目标 |
| exercise_plan_desc    | varchar  | 运动建议   |
| diet_plan_desc        | varchar  | 饮食建议   |
| status                | tinyint  | 状态     |
| activated_at          | datetime | 激活时间   |
| created_at            | datetime | 创建时间   |
| updated_at            | datetime | 更新时间   |

---

## 8.15 VIP 用户表 vip_user

| 字段         | 类型       | 说明                    |
| ---------- | -------- | --------------------- |
| id         | bigint   | 主键                    |
| user_id    | bigint   | 用户ID                  |
| vip_type   | varchar  | quarter/year/lifetime |
| start_time | datetime | 开始时间                  |
| end_time   | datetime | 结束时间                  |
| status     | tinyint  | 状态                    |
| created_at | datetime | 创建时间                  |
| updated_at | datetime | 更新时间                  |

---

## 8.16 VIP 订单表 vip_order

| 字段         | 类型       | 说明   |
| ---------- | -------- | ---- |
| id         | bigint   | 主键   |
| user_id    | bigint   | 用户ID |
| order_no   | varchar  | 订单号  |
| vip_type   | varchar  | 套餐类型 |
| price      | decimal  | 金额   |
| pay_status | tinyint  | 支付状态 |
| paid_at    | datetime | 支付时间 |
| created_at | datetime | 创建时间 |
| updated_at | datetime | 更新时间 |

---

# 九、统计口径定义

## 9.1 健康饮食天数

建议定义为：

* 当日摄入未明显超预算
* 且蛋白达到目标一定比例
* 且无明显暴食特征

v1 可简化为：
`0 <= intake - exercise <= daily_budget * 1.1`
且蛋白摄入达到目标 60% 以上

---

## 9.2 最近7天热量缺口

最近7天 `actual_deficit_calories` 累计值

---

## 9.3 轻断食用餐时长

* firstMealTime = 当日首条饮食时间
* lastMealTime = 当日最后一条饮食时间
* eatingWindow = lastMealTime - firstMealTime

---

# 十、阿里云食物图片识别能力

## 10.1 能力定位

餐前拍一拍接入阿里云市场“食物图片热量识别接口”，用于辅助录入食物。

## 10.2 用户权限

* 普通用户可用
* VIP 用户可用
* 不作为 VIP 独占能力

## 10.3 调用链路

前端上传图片 → 本系统后端 → 调用阿里云接口 → 解析结果 → 返回前端确认

## 10.4 接入原则

* 前端不直连阿里云
* 只由后端调用第三方接口
* 后端做统一解析、日志、重试、错误处理

## 10.5 识别结果处理

优先映射系统 food 库。
若映射失败，则跳转热量查询页自动带关键词。

---

# 十一、接口清单

---

## A. 登录与用户

### 1. 微信登录

`POST /api/auth/wx-login`

### 2. 获取当前用户信息

`GET /api/user/me`

### 3. 获取个人档案详情

`GET /api/user/profile/detail`

### 4. 保存微信头像

`POST /api/user/profile/wx-avatar`

### 5. 保存微信昵称

`POST /api/user/profile/wx-nickname`

### 6. 保存微信手机号

`POST /api/user/profile/wx-phone`

### 7. 保存个人档案

`POST /api/user/profile/save`

---

## B. 首页与今日总览

### 8. 首页今日总览

`GET /api/home/today-overview`

### 9. 获取当日详细记录

`GET /api/daily-record/detail`

---

## C. 食物与饮食

### 10. 获取食物分类

`GET /api/food/category/list`

### 11. 按分类获取食物列表

`GET /api/food/list`

### 12. 热量查询

`GET /api/food/search`

### 13. 食物详情

`GET /api/food/detail`

### 14. 新增自定义食物

`POST /api/food/custom/create`

### 15. 创建/提交餐次

`POST /api/meal/record/submit`

### 16. 获取某餐详情

`GET /api/diet/meal-detail`

### 17. 获取饮食评价

`GET /api/diet/meal-evaluation`

### 18. 删除某条饮食明细

`POST /api/diet/record/delete`

---

## D. 运动

### 19. 运动项目列表

`GET /api/sport/item/list`

### 20. 搜索运动项目

`GET /api/sport/item/search`

### 21. 自定义运动创建

`POST /api/sport/custom/create`

### 22. 新增运动记录

`POST /api/sport/record/add`

### 23. 删除运动记录

`POST /api/sport/record/delete`

---

## E. 预算与档案

### 24. 获取今日预算

`GET /api/budget/today`

### 25. 自定义基础代谢

`POST /api/budget/custom-bmr`

### 26. 恢复默认基础代谢

`POST /api/budget/custom-bmr/reset`

### 27. 重算预算

`POST /api/budget/recalculate`

---

## F. 体重趋势

### 28. 获取趋势页

`GET /api/weight/trend`

### 29. 新增体重记录

`POST /api/weight/record/add`

### 30. 更新初始体重

`POST /api/weight/initial/update`

### 31. 更新当前体重

`POST /api/weight/current/update`

### 32. 更新目标体重

`POST /api/weight/target/update`

---

## G. 我的页

### 33. 我的页摘要

`GET /api/account/summary`

---

## H. 本周统计

### 34. 本周统计

`GET /api/stat/week-report`

---

## I. 餐前拍照识别

### 35. 上传图片并识别

`POST /api/recognize/meal-photo`

### 36. 查询识别结果

`GET /api/recognize/meal-photo/result`

### 37. 识别结果确认并加入餐次

`POST /api/recognize/meal-photo/confirm`

---

## J. 计划与会员

### 38. 获取计划页

`GET /api/plan/detail`

### 39. 激活计划

`POST /api/plan/activate`

### 40. 获取 VIP 套餐

`GET /api/vip/package/list`

### 41. 创建 VIP 订单

`POST /api/vip/order/create`

### 42. 查询 VIP 状态

`GET /api/vip/status`

---

# 十二、核心业务逻辑补充

## 12.1 首次建档逻辑

若首次填写减脂档案时 initial_weight 为空，则自动取 current_weight 作为初始体重。

## 12.2 头像昵称手机号不是预算核心字段

不会触发预算重算。

## 12.3 保存减脂档案后必须重算预算

以下动作发生后必须刷新预算与 daily_summary：

* 修改性别
* 修改年龄
* 修改身高
* 修改当前体重
* 修改目标体重
* 修改目标时间
* 修改基础代谢
* 添加/删除饮食记录
* 添加/删除运动记录

---

# 十三、后端实现建议

## 13.1 推荐技术栈

* Java 17
* Spring Boot 3
* MyBatis-Plus
* MySQL 8
* Maven

## 13.2 代码结构

* controller
* service
* mapper
* entity
* dto
* vo
* calculator
* assembler
* enum
* integration
* job

## 13.3 核心独立组件

### CalorieBudgetCalculator

负责：

* BMR 计算
* TDEE 计算
* 每日缺口
* 每日预算
* 今日还可吃
* 宏量目标计算

### MealService

负责：

* 餐次创建
* 餐次聚合
* 餐次提交

### DietEvaluationEngine

负责：

* 单次饮食评分
* 优缺点生成
* 下一顿建议

### DailySummaryRefreshService

负责：

* 刷新 daily_summary

### AliyunFoodRecognitionClient

负责：

* 阿里云接口调用

### MealPhotoRecognitionService

负责：

* 图片识别记录
* 阿里云识别结果封装

### RecognitionResultParser

负责：

* 识别结果解析
* 与 food 库映射

### PlanEngine

负责：

* 计划生成

### VipService

负责：

* 会员状态与权益校验

---

# 十四、前端展示规则

## 14.1 默认头像

若未获取头像，必须显示默认头像。

## 14.2 默认昵称

若未获取昵称，必须显示随机昵称。

## 14.3 我的页不允许空态

我的页顶部永远要有昵称和头像，不允许空白。

---

# 十五、最终产品定义

这套系统最终不是一个简单的“减肥记录工具”，而是一套完整的：

**微信登录 + 减脂档案 + 每日预算 + 饮食记录 + 运动记录 + 趋势复盘 + 周报统计 + 阿里云识图能力 + 计划引导 + 会员增值能力**

的减脂管理小程序。

---

如果你要，我下一步可以继续把这份终版 PRD 直接拆成两份开发文档：
**一份《后端开发版 PRD》**，一份 **《数据库表结构 + 接口入参出参文档》**。
