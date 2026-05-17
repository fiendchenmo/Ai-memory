# Hermes 会话记忆 2026-05-17

## 工作内容
- **CodeLens 插件端开发计划梳理**（飞书 13:06，314条消息）：制定插件端独立开发路线图 M1-M4，包含排期、代码审查策略、与喵呜（CLI端）的协作分工。M1（根基加固）已执行完成并推送。
- **代码推送解决 WSL 网络问题**（飞书 15:32）：因 WSL 内 `github.com:443` 不通，通过 Windows 侧 git（CMD 批处理脚本）成功推送 `codelens-plugin`（commit `5b087d1`）和 `codelens-java`（rebase 后 `f1618ea`）到 remote main。
- **M1 交付完成**：commit `d0b076c`（28 files, +1656/-753），包含安全修复、Gson 重构、41 个新测试、JaCoCo 配置、构建加固。
- **Common Cache Interface 实现**：在 `com.codelens.common.cache` 包中完成 5 个文件（TTL + LRU），`SummaryCache` → `FileSystemCache` 迁移代码就绪，计划文件 M1.2.10 更新。
- **长期记忆仓库配置与维护**：将 persistent memory（11条笔记+6条用户画像）导出到 `archive/2026-05-17/hermes_persistent_memory.md`；创建 cron job `hermes-长期记忆归档`（每日 21:50 UTC+8）。
- **飞书 bot 昵称更新**：昵称从 "Hermes" 改为 "嗷呜"，同步更新 persistent memory 群聊规则。
- **审批模式修复**：`approvals.mode` 从 auto（无效值）改为 `off`，关闭所有飞书审批卡片，重启 gateway 生效。
- **M1-M4 路线图评审**（飞书 19:38）：对完整路线图（343行）进行风险评估与排期合理性点评，M1 执行已验证模块化推进模式有效。

## 关键决策
- **审批模式永久关闭**：`config.yaml` 中 `approvals.mode=off`，不再弹出任何审批卡片，所有操作默认同意。
- **持久记忆存储策略**：一次性导出 persistent memory 作为基线，不做 cron 每日备份（仅增量会话由 cron job 处理）。
- **长期记忆仓库命名规范**：按 `archive/YYYY-MM-DD/` 每日归档，各 agent 使用前缀隔离（hermes_、claude_ 等），根目录维护 `hermes_INDEX.md`。
- **LLMClient 接口不统一**：X4 项已关闭，插件端与 CLI 端各自保留独立实现。
- **codelens-common 仓库拆分策略**：采用两阶段法——先在各自仓库内重构，再拆分公共模块；不阻塞 M1 执行。
- **飞书群通知**：代码推送完成后在工作室群主线程发送结果通知。

## 待办
- [ ] **CodeLens.java 合并冲突**：codelens-java 仓库 `src/main/java/com/codelens/CodeLens.java` 在 stash pop 时存在冲突，需手动解决。
- [ ] **下一步方向决策**：M1 完成后，选择先开始 M2（体验突破）还是先补全 M1.3.4 测试缺口。
- [ ] **X3 等待喵呜决策**：缓存参数（TTL、最大条目数、Hash 算法）——建议值：7天 TTL、1000 maxEntries、MD5。
- [ ] **X1 等待喵呜决策**：SystemPrompt 共享方案，需等喵呜 A10 完成。
- [ ] **M2.1 Gutter Icon API 兼容性验证**：需在 IDEA 2021.3.1 上做原型验证，是 M2 开始的潜在前置条件。
- [ ] **M3.1 IDE 版本兼容升级**：从 JDK 11+ IntelliJ Gradle Plugin 1.x 迁移至 JDK 17+ Plugin 2.x，建议拆阶段执行。
- [ ] **GitHub 网络不稳定**：WSL 内 `github.com:443` 不可靠，需考虑 CI/CD 和远程协作的替代方案。
- [ ] **Persistent memory 容量告急**：使用率 95%（2,094/2,200 chars），需清理或压缩。
