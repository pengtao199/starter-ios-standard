# Starter Skill Spec

## 目标

为 Codex 提供一个围绕 `starter-ios-standard` 工作的实际 skill 草案，让后续可以按统一规则自动生成：

1. 新项目起手动作
2. 新 Feature 骨架
3. 新页面骨架
4. 新付费页骨架
5. 新设置区块

## 触发场景

当用户表达以下需求时，应命中 Starter skill：

1. “基于 starter 开一个新 app”
2. “给 starter 加一个新 feature”
3. “帮我生成一个设置页模块”
4. “加一个订阅页/付费页”
5. “按 starter 规范搭页面”
6. “判断这个新 app 更适合 Lite / Standard / Pro 哪一档”

## Skill 的输入

### 1. 项目类型

1. 工具类
2. 订阅类
3. 内容类

### 2. Starter 档位

1. Lite
2. Standard
3. Pro

### 3. 目标动作

1. `select-starter-tier`
2. `bootstrap-project`
3. `create-feature`
4. `create-page`
5. `create-paywall`
6. `create-settings-section`

### 4. 业务名与配置名

至少需要：

1. Feature 名
2. 页面名
3. 是否需要网络
4. 是否需要订阅
5. 是否需要法务入口

## Skill 的输出

每次执行后，至少要给出：

1. 目标目录落位
2. 需要新增/修改的文件清单
3. 模板代码骨架
4. 需要新增的本地化 key
5. 需要补充的配置项
6. 需要补读的规则文档

## 必须遵守的规则

1. 先读 `Rules/AGENTS.md`
2. 再读命中的专项规则
3. 先改配置，再改页面
4. 生成代码时不得跳过双语本地化
5. 不得默认引入业务专属 SDK

## 推荐输出模式

### `select-starter-tier`

输出：

1. 推荐档位
2. 推荐原因
3. 本项目当前不应提前引入的能力

### `bootstrap-project`

输出：

1. 需要先修改的 `Config`
2. 需要先验证的系统页面
3. 第一批要保留/删除的 starter feature

### `create-feature`

输出：

1. `Presentation / Application / Domain / Infrastructure` 文件骨架
2. 是否需要 `RepositoryProtocol`
3. 是否需要 `API`
4. 必须新增的本地化 key

### `create-page`

输出：

1. 页面主状态模型
2. 是否使用 `PageStateContainer`
3. 首屏使用 `skeleton` 还是 `loading`

### `create-paywall`

输出：

1. 付费页结构
2. 依赖的配置项
3. 法务入口
4. 恢复购买入口

## 当前边界

1. 当前只产出 starter 内 skill 草案
2. 当前不直接安装到本机 skills
3. 当前不负责重媒体、重缓存、广告链路
