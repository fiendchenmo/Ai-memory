# Hermes 会话记忆 2026-05-26

## 工作内容

### P-4 called_by 跨文件跳转 → 三大Bug修复（推送上线）
- **Fix 1 — AnalysisRunner传null修复**：`AnalysisRunner` 改用 `PsiGraphManager.getEngine(project)` 不传 null，解决 called_by 后台查询 engine 为 null 的问题
- **Fix 2 — Getter/setter过滤规则修正**：从 `startsWith("get")/startsWith("set")` 前缀判断改为按**参数个数**过滤（setter→1个参数，getter/is→0个参数）。防止 `setAttorney(3个参数)` 等业务方法被误过滤
- **Fix 3 — SQLite驱动显式加载**：`PsiGraphEngine.open()` 加 `Class.forName("org.sqlite.JDBC")` 显式加载驱动，解决 IntelliJ 插件类加载器下 SPI 失效问题
- **P-4跨文件跳转格式**：节点格式 `文件名#行号|类.方法`，`CallerNodeData` 存文件路径

### Called_by 后台线程方案
- called_by 不能在 EDT 执行（DumbService 导致 PSI 返回空）
- 需在后台线程用 `ReadAction.compute` + `ProgressManager.runProcess` 包裹
- `AnalysisRunner` 中已实现后台查询 + fallback 链路
- 日志排查关键词：`[called_by]`

### PsiGraphEngine 重构引发的问题
- graph.db 全量重建时大量 `begin 0, end -1, length XXX` 错误
- 根因：Lombok 合成类/部分PSI元素 `getTextOffset()` 返回-1
- 已修复 `PsiGraphEngine` 中对应逻辑

### 基准测试
- 默默在 IDEA 手动跑 T1-T12 基准测试（12文件分层抽样）
- 测试结果：T10 PmsBillButtonHandler（通过✅），T11 PaymentResponse（通过✅）
- T11 所有方法显示 Line: 1 — Lombok 代码生成固有现象，不影响功能
- T10 Called By 数据完整 — 私有方法全都正确反向引用入口方法

### OpenRouter DNS 被墙问题定位
- `api.openrouter.ai` DNS 解析被 GFW 封锁，WSL 和 Windows 都解析不了
- `api.deepseek.com` 正常（112.46.51.207，国内公司）
- 建议用 Hermes gateway (127.0.0.1:8642) 绕开 OpenRouter，直连 DeepSeek

### 归档（cron job 产物）
- 20:01 — 喵呜待办清单生成（无新增待办，C-3/C-4/C-5 评审通过）
- 21:00 — 每日工作总结（基准测试进行中，called_by修复完成）

## 关键决策
- **Getter/setter过滤规则**：按参数个数判断（set→1 param，get/is→0 param），不按方法名前缀。防止误过滤业务方法
- **Called_by 查询线程模型**：固定为后台线程 + ReadAction.compute + ProgressManager，不在 EDT 执行
- **基准测试验收标准**：V3 面板展示 + 行号正确 + Called By完整 + L1校验通过 + 不崩溃
- **OpenRouter 被墙处理方案**：用本地 Hermes gateway 代理，不走 OpenRouter 域名

## 待办
- [ ] 收基准测试结果 → 分析报告写到 `docs/benchmark/`
- [ ] 回答默默问题：反向依赖点击行号跳转到目标文件 — 是 P-4 已实现功能，非遗漏
- [ ] EntroCamp L3 学习（反馈吸收与行为修正）
- [ ] called_by 在测试中如果还有问题，继续跟进 PSI fallback 行号确认
