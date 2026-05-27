# Hermes 会话记忆 2026-05-27

## 工作内容

### 1. IntelliJ Plugin Build Errors 修复（session: 18:26~20:59）
- **Called By 死锁修复** — `CalledByResolver.java` 新增 `resolveByName()` 纯 SQLite 查询，`AnalysisRunner.java` 删 `ReadAction` 包装，零 PSI 访问，彻底解决死锁问题
- **重建索引/db 路径** — `JavaParserIndexEngine.java` db 路径改到 `/.idea/codelens/graph.db`，meta 表持久化状态
- **测试污染修复** — `PsiGraphEngineTest.java` cleanup 路径对齐
- **面板提示状态** — `V3ToolWindowPanel.java` 🔄/ℹ️/✅ 三种状态显示
- **getter/setter 不过滤** — 只过滤 `toString/hashCode/equals/clone/finalize`，其他 getter/setter 正常显示
- **结果验证**：121 测试全通过 ✅ + `clean buildPlugin` 通过 ✅
- **runIde 验证**（默默操作）：`called_by` 索引跑通，面板显示 `ℹ️ 索引已完成，未找到此文件方法的反向调用`，确认不是 bug，是 FMP 项目方法走继承链调度

### 2. AHK 基准测试自动化脚本（session: 18:14~20:50）
- 编写 `benchmark-automation.ahk` v1.1 — 自动循环 12 个基准测试文件：Ctrl+Shift+N 打开 → Ctrl+Shift+A 触发分析 → 等待 → 截图右侧 ToolWindow
- 插件通过文件系统解压安装到 IDEA 插件目录
- 脚本已启动运行

### 3. 插件端主管工作流规范（session: 20:55~21:30）
- 默默给嗷呜立了**"插件端主管"**角色规范
- 核心变更：嗷呜从"兼主管+开发"改为**只做主管**，不再是代码执行者
- 工作流：收到问题 → 分析根因 → 出修复方案 → 等默默审批 → 派Claude Code/Cline执行 → 按审查清单审查 → 推送
- 三条硬规则：禁止裸改、先写后改（复杂问题先写方案）、改完必审
- 审查清单5项：源码vs测试、断言放宽、删测试、范围超方案、逻辑不自洽
- 反模式：红改绿、打圈圈（同一问题改两次以上还在原方向加码）、头痛医头、先推不说
- 三遍定律：同一问题重复3次 → 停下来复盘
- 编写规范已写入长期记忆和 `.clinerules`
- 复杂/简单问题判断标准也已界定

## 关键决策

- **called_by 对 FMP 项目某些文件为空** — 确认不是 bug，方法走基类模板方法/继承链调度，SQLite 查不到直接调用是正常行为
- **隐形依赖（基类→子类调度）** — 排期到 6/12~6/16（等到喵呜出知识图谱 Schema 后做 Domain View 适配）
- **嗷呜角色变更** — 从"写代码"转为"只做主管+审查"，代码执行移交给 Claude Code/Cline
- **排期管线**：多 Agent（5/28~6/6）→ KnowledgeGraph（6/7~6/11）→ Domain View（6/12~6/16）

## 待办

- 🔄 **common 模块排期**（计划 5/28~6/16）— 待喵呜回复
- 🔄 **全包分析 / Diff Impact / 测试感知 排期** — 待喵呜回来排期
- 🔄 **多 Agent 流水线启动**（5/28 起）— 喵呜明天开始
- 🔄 **知识图谱 Schema**（6/7~6/11）— 隐形依赖的前提，等喵呜出接口
- AHK 基准测试跑完后，根据截图结果分析 V3 面板展示效果
- 如果需要，做 UI 增强（等 V3 稳定后）
