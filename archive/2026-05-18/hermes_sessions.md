# Hermes 会话记忆 2026-05-18

## 工作内容

### 1. 配置优化
- 飞书群关闭 tool_progress 和 interim_assistant_messages
- gateway_notify_interval 改为 600s
- 飞书消息格式改为简洁结构化，只发最终更新

### 2. M1 加固 — P0/P1 修复（codelens-plugin）
- **P0-5 重复IO修复**：`CodeLensAnalyzeAction` 从磁盘读源文件 3 次 → 统一使用 `PsiFile.getText()`（内存读），消除全部三次 `Files.readAllBytes` 调用。涉及 5 个文件修改（`CodeLensAnalyzeAction.java`, `SummaryCache.java`, `SummaryCacheTest.java` 等），构建测试均通过。
- **P0-6 原生库沙箱修复**：`FtsIndexer` SQLite 原生库解压路径从 `projectDir/.codelens/native` 改为 `PathManager.getPluginTempPath()`，避免沙箱安全策略拦截。构建测试均通过。
- **P1-4 空 catch 块**：`FileSystemCache` 两处 + `FtsIndexer.close` 一处，添加 `LOG.warning`。已完成。
- **P1-8 LRU 缓存淘汰**：`Cache.java` / `CacheConfig.java` / `FileSystemCache.java` — 开始查看代码结构，上限 1000，未完成。
- **P1-10 校验器集成**：L1/L2 校验器集成，未开始。
- **P1-5 God Class 拆分**：未开始。

### 3. 卡片模式评估
- 方案A：多 Provider LLM 支持（P2，1天）
- 方案B：批量分析 + 卡片展示 + 调用关系图（P2→P3，batch 0.5d + 卡片 1d + 调用图 1.5d）
- **决策**：两个都要，方案B优先，方案A 排 P2

### 4. 长期记忆归档方案
- 三层检索：memory → session_search → grep
- 每日 21:55 cron 定时归档 + git commit
- `hermes_INDEX.md` 索引维护
- 90 天后按月压缩

### 5. 沙箱 IDE 运行（技术问题排查）
- coroutines-agent jar 缺失导致 `runIde` 失败
- IDE 内 Gradle 面板无法传递 `-x test` 参数
- 解决方案：WSL terminal 直接运行 `gradle runIde --no-daemon -x test`

## 关键决策

| 决策 | 结论 | 拍板人 |
|------|------|--------|
| 飞书消息格式 | 简洁结构化，只发最终更新 | 默默 |
| 卡片模式优先级 | 代码审查→基准测试→M2.2批量分析+卡片→调用关系图 | 默默 |
| 长期记忆归档 | `C:\Users\dj\long-term-memory\`，21:55 cron，三层检索 | 默默 |
| P0-5 读取策略 | 统一使用 PsiFile.getText()（内存读），消除磁盘 IO | 默默 |
| P0-6 原生库路径 | PathManager.getPluginTempPath()，沙箱兼容 | 默默 |
| P1-4 空 catch 处理 | 添加 LOG.warning，不吞异常 | 默默 |
| 方案 A vs B | 方案B（批量分析+卡片+调用图）优先，方案A 排 P2 | 默默 |

## 待办

- [ ] P1-8 LRU 缓存淘汰（上限 1000）— 已开始
- [ ] P1-10 校验器集成（L1/L2）
- [ ] P1-5 God Class 拆分
- [ ] M1.1 安全修复（API Key 加密存储）
- [ ] M1.2 剩余重构任务
- [ ] M1.3 测试补全
- [ ] M1.4 构建加固
- [ ] 代码审查收敛
- [ ] 基准测试
- [ ] M2.2 批量分析 + 卡片展示
- [ ] V2 调用关系图
- [ ] 方案A 多 Provider LLM 支持（P2）
