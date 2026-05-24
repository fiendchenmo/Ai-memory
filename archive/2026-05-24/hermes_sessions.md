# Hermes 会话记忆 2026-05-24

## 工作内容

### 上午 — 控制论讨论与 ACTIVE.md 清理 (Feishu)
- 默默分享了一组关于**控制论与 AI 工程**的深度内容（来自小红书 11 页长文）
  - Ashby 控制论：黑箱方法、负反馈 vs 正反馈回路
  - Harness Engineering 本质：System Prompt=方向盘、Eval=仪表盘、RAG=控制带宽、Retry/Fallback=纠偏执行器
  - 规则一：永远不让模型自评（独立 Eval 组件）
  - 规则二：每种失败模式配一个约束手段
  - 规则三：微小偏差不值得 re-prompt，设容忍阈值
  - 规则四：Prompt 修改单次不超过 20%，必须做 A/B
  - 规则五：约束要分层，至少四层（宪法→策略→执行→兜底）
  - 规则六：看不见就控不了，structured output 就是加传感器
  - 正反馈陷阱：Agent 错误信号自我放大，需要独立 eval 打断回路
- 讨论 CodeLens 架构如何映射这些控制论原则：
  - PsiGraphEngine = 独立传感器（不依赖 LLM）
  - 三层降级（SQLite→PSI→空提示）= 正反馈断路器
  - 代码顺序驱动的输出格式 = 加传感器
- ✅ **ACTIVE.md 精简：** 131 行 → 83 行（-37%）
- ✅ 归档旧内容：Schema v2 对齐、OutputNormalizer、CORE_RULES 17-22、severity 标准对齐、architecture_issues 上限、lineOffset 关闭、温度锁定交付、三层方案实施

### 下午 — called_by 修复 + FTS5 重复清理
- **CrossFileRefResolver 行号修复：** `getTextOffset()` 返回字符偏移量不是行号 → 改为 `Document.getLineNumber()` 转真实 1-based 行号
- **addTypeRef 签名修复：** 添加 `javaFile` 参数传到 `offsetToLine()` 转换
- **FTS5 反向查询重复清理：** CodeLensAnalyzeAction 中 FTS5 REVERSE DEPENDENCIES 段与 called_by（PsiGraphEngine + PSI fallback）功能重复 → 整段删除（~120 行）
- **环境变量清理：** DeepSeekSettingsConfigurable 中残留的 `resolveApiKey()` / `getEnvVarName()` 引用全清理
- 重新打包验证通过

### 傍晚 — C-10 温度锁定交付确认 & 类级 called_by 缺口发现
- **C-10 ProviderPreset 温度锁定：** ✅ 可验证（UI 感知型锁定），等默默打包后确认
- **resolveImports() 删除：** ✅ 已合入 main
- **CI 全绿：** ✅ 编译 + 106 测试通过
- **Bug: `long` 基本类型出现在 cross_file_refs：** `resolveFieldInjections()` 没有过滤 `PsiPrimitiveType`，导致 `long serialVersionUID` 被当成跨文件引用 → 加 `type instanceof PsiPrimitiveType` 过滤 ✅
- **called_by 继承多态问题：** `EcsBillDataSaveHandler extends EcsBillBaseHandler` — PSI 精确搜索搜不到通过父类类型调用的引用
  - 决定：排到 Phase 2 隐式依赖检测（P0 #4）一起处理
- **called_by 索引自动触发：** 首次分析文件时后台全量重建 ✅

### 晚上 — PaymentResponse 字段引用 & called_by 方法级 vs 类级设计缺口
- 用户问：`private PaymentResponse payment` 在分析 `PaymentResponse.java` 时会显示被调用了吗？
- 分析结果：**不会** — called_by 是方法粒度，只查 `PsiMethodCallExpression`
- **CalledByResolver 三层链路已修复**（SQLite→PSI→空提示），但接口/POJO 场景查不到调用方
- 用户提供 IntelliJ 截图：`IHomePageTitleFactory` → 4 个 usage（import/FIELD/implements），0 个方法调用
- **结论：问题不在索引，在设计 scope — 只追踪方法调用不追踪类级引用**
- 方案建议：改 `CalledByResolver` 搜类引用（`ReferencesSearch.search(psiClass, ...)`）代替方法引用
- 用户决定：等 Phase 2 一起处理

## 关键决策

| 决策 | 结论 | 原因 |
|------|------|------|
| **called_by 类级引用** | 排到 Phase 2 #2/#4 隐式依赖检测 | 设计 scope 问题，不是 bug |
| **FTS5 反向查询** | 删除 | 与 called_by（PsiGraphEngine + PSI fallback）功能重复 |
| **环境变量读取** | 清理删除 | 已不再使用 |
| **CrossFileRefResolver 行号** | 用 Document.getLineNumber() | getTextOffset() 返回字符偏移不是行号 |
| **基本类型过滤** | 加 PsiPrimitiveType 检查 | long serialVersionUID 被误当作跨文件引用 |

## 技术债务

| 项 | 优先级 | 描述 |
|----|--------|------|
| **called_by 类级引用** | 🔴 P0 | 字段声明/extends/implements/方法参数类型 → class_used_by 表 |
| **继承多态 called_by** | 🔴 P0 | 搜索当前方法 + 父类/接口同名方法合并结果 |
| **called_by 索引重建** | 🟡 P2 | graph.db 不存在，索引从未建过 |

## 待办
- 🟡 [ ] 默默打包验证 C-10 温度锁定
- 🟡 [ ] Phase 2 排期（含 #2 impact analysis + #4 隐式依赖检测）
- 🟡 [ ] CalledByResolver 改为搜索类引用（PSI fallback 层）
