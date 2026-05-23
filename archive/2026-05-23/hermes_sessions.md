# Hermes 会话记忆 2026-05-23

## 工作内容
- **PsiGraphEngine v1.0 技术方案设计完成** — `docs/architecture/psi-graph-engine.md` (879行)，评审通过
  - 4 层架构：Layer 0 PSI缓存 → Layer 1 图索引器 → Layer 2 SQLite邻接表 → Layer 3 加权上下文提取
  - method_nodes + class_nodes 双节点表，qualified_sig + content_hash 仲裁 UNIQUE 冲突
  - method_calls_v2 加 confidence 三级（RESOLVED/LIKELY/UNRESOLVED）
  - FTS5 content=method_nodes 挂载
  - 增量：保存时 content_hash 触发；迁移：index.db → graph.db，保留 index.db 做降级
  - 交付估：4 天（含9个测试Case）
- **003 需求文档** — `docs/requirements/003-psi-graph-engine.md` 完成，等待默默评审
- **GitHub CodeGraph 项目调研** — 重点分析 CGC (Python+KuzuDB+MCP Client)、xnuinside/codegraph (轻量Python)、codegraph-rust (Rust+SurrealDB)，CGC 图库选型和 agentic 工具设计最有参考价值
- **新 LLM 输出结构 v3 设计**（等后期实现）
  - 代码顺序驱动：summary → fields → methods（每个方法含 params/description/logic_summary/calls/return/risks/exceptions）
  - methods[].risks 替代顶层 risks[]
  - fields[] 替代 dependencies[]
- **包级/模块级分析设计**（等后期实现）
  - 右键目录自动判断包级/模块级/混合视图
  - 包内依赖图 + 跨包依赖 + 循环依赖检测
  - 不跑额外 LLM，数据从单文件分析聚合
- **Common 模块跨端协调** — 4条变更记录在 common-change-tracker.md + commit 6eb94b6
  - 移除 architecture_issues、EvidenceValidator methodRanges、SystemPrompt [FACT]/[INFER]、JSON Schema 版本化 + Normalizer
- **喵呜交付排期确认**：
  - 5/24：移除 architecture_issues
  - 5/26：ProviderPreset 温度锁定
  - 5/27：EvidenceValidator + methodRanges
  - 5/27~28：JSON Schema 版本化 + Normalizer
  - 5/28：SystemPrompt [FACT]/[INFER]

## 关键决策
- PsiGraphEngine 4 天交付计划（含9个测试Case），等默默评审 003 后 Cline 启动
- v3 新输出结构和包级分析暂不实现 — 喵呜说 CLI 端能力不够，等 v3 统一
- 光标跟随代码滚动 Phase 2 不做，等后期
- 插件端 PsiGraphEngine 和喵呜的 common 改动并行开发，无阻塞关系
- common-change-tracker.md 表格记录变更，git 提交同步

## 待办
- 🔄 默默评审 003 需求文档 → 通过后飞书通知嗷呜启动 Cline
- 喵呜从 5/24 开始处理 architecture_issues 移除
