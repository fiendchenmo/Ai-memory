# Hermes 会话记忆 2026-05-19

## 工作内容
- **P2 Fix 全部完工 — M1 项目加固验收通过**
  - `FtsIndexer` 实现 `AutoCloseable`（FTS5 空转修复）
  - `CacheKeyGenerator` MD5 fallback → `AssertionError`（PSI 判空修复）
  - `EvidenceValidator` 新增 UNKNOWN 枚举（置信度补充）
  - `PsiExtractor` 空 catch + 死代码清理
  - `LLMClient` Gson 构建请求体 + 指数退避重试（max 3 次）
  - 代码审查修复：Logger 声明、escapeJson 删除、qualifiedName 拼接、try-with-resources、重复方法消除
- **Schema v2 字段对齐**（`commit 4263b82`）
  - `risks` 新增 `type(SECURITY|PERFORMANCE|MAINTAINABILITY)` + `impact`
  - `keyMethods.calls` 改为 `String[]` 数组格式，新增 `annotations`
  - `keyMethods` 移除 `complexity`
  - `severity` 统一为大写枚举 `HIGH|MEDIUM|LOW`
- **UNKNOWN 置信度**（`commit 474f081`）：`EvidenceValidator` 新增 UNKNOWN 枚举，`totalChecked==0` 时返回 UNKNOWN
- **buildBase() 方案定稿**：三层 Prompt 结构，`buildBase()` = 角色 + JSON_SCHEMA + CORE_RULES 1-16，`build()` = `buildBase()` + CLI 端规则 17-21
- **CODELENS_SPEC.md 生成**：在 codelens-plugin 仓库根目录生成完整规格文档
- **架构评审遗留修复全部通过**：P2-N4、M-P2-3、P2-N6、P1-N1、P1-N2、M-P1-7 及 #1-#5/#9

## 关键决策
- `severity` 统一为大写枚举 `HIGH|MEDIUM|LOW`（插件端与 CLI 端对齐）
- `architecture_issues` 不加硬上限，改为 Prompt 建议 "3-5 条"
- 温度锁定推迟到 Phase 2（与 ProviderPreset 一起处理）
- CallIndex 迁移推迟到 Phase 2（避免与当前修复冲突）
- 模型特性标记推迟到 Phase 2
- 日常用 DeepSeek v4-flash，复杂分析切 v4-pro，Coding Plan 留给 Claude Code
- P2 Fix 全部完成，M1 项目加固结束，无遗留 P2 级别问题

## 待办
- 🔴 Schema 字段命名确认（`severity` 大小写、`calls` 类型、`impact` 有无）— 等喵呜回复
- 🟡 UNKNOWN 置信度同步 — 等喵呜回复
- 🟡 buildBase() 实现确认 — 等喵呜回复
- 🟡 输出归一化层需求 — 等喵呜回复，需求文档已出
- 🟡 lineOffset 恒为 0 修复 — 等喵呜回复，已确认是 bug
- 🟡 Prompt 强化（dependencies 约束）— 需与归一化层配合
- 🟢 CallIndex 迁移 — 推迟 Phase 2
- 🟢 模型特性标记 — 推迟 Phase 2（与 ProviderPreset 一起）
- 🟢 温度锁定 — 推迟 Phase 2
- 🟢 模型样本跑测 — 排在 Schema 对齐 + bug 修复之后
- 🟢 memory 瘦身 — 移入 ACTIVE.md 的条目可清理
