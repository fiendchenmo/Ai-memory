# Hermes 会话记忆 2026-05-21

## 工作内容

### 上午/下午 — 基准测试
- **A组 DeepSeek v4-flash 基准测试完成** — 全量12文件跑完，L1通过率100%（12/12），行号精确率100%，FinalScore 77.2/100
- **B组 DeepSeek v4-Pro 测试** — 只跑了T1（3x慢+卡IDE+质量无明显提升），结论：放弃全量，Pro只适合单文件攻坚
- **基准测试规范v2.0更新** — 12个测试文件定稿、多模型方案（A组flash全量→B组pro→C组千问抽样→D组Kimi→E组豆包）、禁用缓存、简化执行流程
- **C组 千问 qwen-plus 抽样测试** — 抽取T1/T2/T6/T11四个文件完成测试，结果分析：L1通过率100%，但输出比Flash精简（Deps数量少、项数少），Flash更优
- **豆包 doubao-pro-32k 尝试** — 未开通权限（InvalidEndpointOrModel.Not Found），建议改用 `doubao-seed-2-0-lite-260215`

### 下午 — 插件端 CI & 基础设施
- **插件端 CI 配置编写** — 创建 `.github/workflows/ci.yml`（`/mnt/c/Users/dj/codelens-plugin/.github/workflows/ci.yml`）
  - 流程：`checkout → JDK 11 → chmod +x → test → verifyPlugin → buildPlugin → upload artifact`
  - 对齐喵呜 CLI 端 CI 结构：加了 `v*` tag 触发 + `notify-on-failure` job
  - commit `0fe9f50`（Phase 2 kickoff）
- **JitPack 依赖升级 v0.2.2 → v0.2.3** — `build.gradle` 更新依赖版本（含 Few-shot 规则 23-25），编译+全部40+测试通过 ✅
- **Cline 入职 & `.clinerules` 配置** — 编写插件端编码规范 `.clinerules`（`/mnt/c/Users/dj/codelens-plugin/.clinerules`）
  - 含技术栈/JDK 11/Gradle/JUnit 4/构建命令/禁区/工作流程/角色定义
  - Cline 每次启动自动读取，知道边界
- **AGENTS.md 更新** — 定义了 Cline 作为全能助手（非编程）的角色，Claude Code 作为编程搭档

### 晚间 — 安全事件 & 检查
- **豆包 vision key 泄露至飞书群（安全事件）**
  - 根因：每日晚间总结 cron job 将豆包 vision key 明文写进输出，自动发到飞书"工作室"群
  - 修复：✅ cron prompt 加安全规则（禁止输出任何 key/token/密码明文）
  - 修复：✅ memory 中 key 明文替换为仅保留模型名
  - 建议：去 Volcengine Ark 控制台 revoke 旧 key，重新生成
- **飞书长连接状态确认** — 21:16 排查飞书长连接
  - WebSocket 长连接 ✅ 活跃（最后一次连接 14:26:04）
  - Gateway 进程 ✅ 运行中
  - ⚠️ 发送消息失败：21:09~21:14 连续5次报错 [99992402] field validation failed
  - 可能原因：飞书 API 的 app_token / tenant_token 过期
- **ACTIVE.md 更新** — 当前阶段标记为基准测试进行中，A组Flash已完成

## 关键决策

- **B组 Pro 放弃全量基准测试** → 3x慢+卡IDE，只适合单文件架构攻坚
- **千问 qwen-plus 对比结论** → L1通过率与Flash持平（100%），但输出项数和丰富度不如Flash，Flash更优
- **豆包模型切换** → doubao-pro-32k 未开通权限，改用 `doubao-seed-2-0-lite-260215`
- **如果豆包也无明显差异** → 基准测试收尾，不再继续跑更多模型
- **Git 历史清理（CodeLens.txt 含4个 key）** → 建议方案B（废弃key，不推filter-repo），等默默决定
- **Cline 工作分配** → 等喵呜出项目编码规范后 review，再分配第一个插件端 task
- **cron prompt 安全加固** → 禁止输出任何 key/token/密码/secret 明文值

## 待办

- [ ] 豆包 doubao-seed-2-0-lite-260215 抽样测试（T1/T2/T6/T11）
- [ ] 如趋势已明显，基准测试收尾，出完整三模型对比报告
- [ ] 去 Volcengine Ark 控制台 revoke 泄露的豆包 vision key，生成新的
- [ ] Git 历史清理 — 等默默决定废弃 key 还是 git filter-repo
- [ ] 🔄 Cline 编码规范 review — 等喵呜初版出来后 review 补充
- [ ] 🔄 喵呜待回复事项（管理复盘笔记同步、JavaParser底图漏提取、CLI端CI配置、JitPack JDK版本、需求#5/#6/#7、common独立模块分割、Round 1 修复#8-#10）
- [ ] Phase 2 排期（CallIndex迁移、温度锁定等）
