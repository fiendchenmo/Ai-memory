# Hermes 持久记忆基线导出

> 导出时间：2026-05-17 15:19
> 来源：Hermes Agent 内部 persistent memory
> 说明：跨会话稳定知识基线，非每日增量。重大变更时手动更新。

---

## MEMORY（个人笔记）

### 开发环境
- WSL+Windows双环境
- WSL terminal长操作用background
- IDEA需WSL JDK（非Windows JDK），WSL项目建议移Windows文件系统
- build.gradle设updateSinceUntilBuild=false

### CodeLens 项目概览
- Java遗留代码智能分析，CLI+IDE双模
- Hermes=插件端（codelens-plugin `C:\Users\dj\`），喵呜=CLI端（codelens-java `C:\workspace\`）
- 栈：JavaParser+SQLite FTS5+DeepSeek LLM+IntelliJ PSI
- 默认模型deepseek-v4-flash（分析用v4-pro）
- 目标：Windows+IDEA 2021.3.1
- 三级风险：🔴安全 > 🟡事务 > 🟢性能

### Windows sandbox 锁
- buildPlugin报prepareSandbox文件占用 → `taskkill /f /im java.exe && taskkill /f /im idea64.exe && rmdir /s /q build\idea-sandbox` 后重试
- `cmd.exe /c` 中 & 会被WSL解释为后台 → 用 && 替代

### 模型自动切换 cron
- `switch-to-pro-daytime` 07:00 → deepseek-v4-pro
- `switch-to-flash-evening` 19:00 → deepseek-v4-flash
- 均为 no_agent 脚本，执行 `hermes config set model.default`

### Coze 聊天项目
- 路径：`~/coze-chat/`
- Python stdlib 后端 + 自包含前端（手机自适应）
- Coze API：`POST https://5tkfcxq3jf.coze.site/stream_run`（SSE流式）
- session_id, project_id 存 `.env`
- 启动：`python3 backend.sh` → :8080
- 手机访问：`http://192.168.0.3:8080`
- WSL2端口转发：netsh不稳定，可靠方案→ `%USERPROFILE%\\.wslconfig` 设 `networkingMode=mirrored+firewall=false` 后重启WSL
- 电脑192.168.0.3，手机192.168.0.2
- 镜像模式下8080可能被Windows占需换端口

### Claude Code 模型自动切换（双路径）
- Windows 侧 `C:\Users\dj\.claude\settings.json` 的 model 字段生效
- WSL 侧 `/home/dj/.claude/` 的 settings.json + current-model 作备份
- cron 脚本同时更新两边
- 从 WSL 启动 claude（实际是 Windows 二进制）时 settings.json 的 model 有时不生效 → wrapper 脚本 `~/.hermes/scripts/claude-launch.sh` 传 `--model` 参数

### 代码修复偏好
- 用 numbered list 标问题 1/2/3，每个带清晰技术描述和修复方案
- 末尾"要我帮你改吗？"征求意见
- 如果用户明确说"你先修改"则直接干不问
- 不要过度解释，直击痛点修 bug

### 用户沟通风格
- 偏好直接简洁、action item驱动的讨论
- 重视进度对齐和主动沟通——主动推消息
- 心情好的时候说"OKK"、"晚安"
- 重视效率，会简化复杂方案（如反对symlink选版本号）
- 管理风格：瓶颈对齐资源，谁慢谁专攻

### 群聊处理规则
- 只在被 @嗷呜 显式提及时才回应
- 未提及的消息忽略，不处理、不回复

### CodeLens 治理定稿（2026-05-17）
- 宪法12方面（Hermes引擎/UI/缓存存储，喵呜prompt/校验器/缓存策略/CLI/Schema，默默LLM接口/通用层制度/质量/测试/构建目标）
- 程序法5条：变更通知48h/破坏变更默默批/依赖准入默默批JDK1.8上限/IMPACT四类链追踪/紧急修复直接改
- 开发原则：先想后做/简单优先/一次一改/目标驱动
- common寄生CLI仓库，>10文件或>3次同步出错拆独立仓
- `GOVERNANCE.md` 在 `codelens-common/`

### 已关闭决策
- X4 A6：LLMClient 接口各自保留不统一，两端依赖不同，等插件功能稳定后再统一重构

---

## USER PROFILE（用户画像）

### 基本资料
- 默默（Momo），中文技术沟通简洁直接
- WSL（Ubuntu）+Windows双环境
- IDEA 2021.3.1，JDK 1.8+11
- DeepSeek API
- 偏好本地先建再部署

### 审批偏好
`approvals.mode=off`，不再弹出审批卡片。所有操作默认同意。
- 不需要安全扫描弹窗，所有操作默认同意

### CodeLens UI 偏好
- Model 选择用下拉框（JComboBox）不用文本框
- 展示 label 含弃用日期但存储值不含
- 新安装默认 deepseek-v4-pro

### @Hermes 语义
- 默认指向 codelens-plugin（插件端）
- CLI端会特别说明"喵呜"或"CLI端"
- 专注插件代码即可

### Code Review 质量标准
- 结构化JSON输出优先于自由文本
- 风险三级分类（🔴安全 > 🟡事务逻辑 > 🟢性能规范）
- 每条结论必须带行号
- 偏好格式：dependency(name/type/line/reason) + risk(description/line/severity/suggestion) + architecture_issues
- 和@喵呜协作review，双方交叉确认
- 熟悉RuoYi框架Service层惯例

### 沟通分工
- 喵呜：prompt/校验器拍板，Hermes：引擎/UI执行
- 喵呜给方案 = 执行指令，直接改不讨论
- 尊重分工：喵呜(prompt/校验器)拍板，Hermes(引擎/UI)执行

---

## 索引关键词

- hermes/codelens-plugin: 插件端开发
- 喵呜/codelens-java/cli: CLI端
- long-term-memory: 本仓库
- Coze: 聊天项目
- 治理: GOVERNANCE.md
- crons: 模型切换、记忆归档、喵呜提醒、晚间总结
