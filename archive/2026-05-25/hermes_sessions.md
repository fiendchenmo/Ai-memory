# Hermes 会话记忆 — 2026-05-25

## 工作内容

### 1. WSL 连接诊断 + DeepSeek 配置修复（15:19~16:30）
- **WSL 全栈诊断**：内存 2.7Gi 空闲、磁盘 2% 使用、ping 0% 丢包、systemd running — 全部正常
- **根因定位**：`.wslconfig` 设 `networkingMode=mirrored` → Windows 网络变更时 WSL eth0 DOWN 重建
- **决策**：暂不改 NAT，下次再断时实时排查
- **DeepSeek API 连接修复**：`config.yaml` 的 `providers:` 下缺 `deepseek` 条目，新会话启动时读不到 key（只在 `.env` 里有）
- **修复**：补上 `providers.deepseek.api_key` 配置，curl 验证返回 HTTP 200
- **教训**：DeepSeek key 必须在 `providers.deepseek.api_key` 显式声明，光写 `.env` 不够

### 2. REQ-C7 P1×3 代码审查（15:28~17:00，pro 深度模式）
- 审查了 Claude Code 对三个 P1 的修复：
  - **ConstraintValidator.java** — 方法签名正则修复 ✅
  - **ConfidenceThreshold.java** — 阈值逻辑修复 ✅
  - **CrossValidator.java** — 中文关键词依赖修复 ✅
- 用 pro 模型做了深度第二次审查，三个 P1 修复都通过了
- **评估两个边界问题**：
  - 嵌套括号（ConstraintValidator 正则）→ 🟢 低优，等遇到 case 再修
  - methods fallback 类别不匹配 → ❓ 无法评估，等具体 case
- **默默拍板**：两个都不值得现在花时间，等喵呜双模式输出就绪后直接开 P-2 V3 输出

### 3. 待办清单同步确认（20:05~）
- 20:00 cron 生成喵呜待办清单（4 项待办 + 6 项已解决）
- 默默说"这些在其他会话已经确认过了"
- 查后发现记忆确实没同步，问默默要直接告诉我结果还是确认结论 — 无后续回复

## 关键决策

| 决策 | 结论 | 拍板人 |
|------|------|--------|
| WSL 网络模式 | 暂不改 NAT，下次断时实时排查 | 默默 |
| nested parentheses 边界问题 | 不做，等真实 case | 默默 |
| methods fallback 类别不匹配 | 不做，等具体 case | 默默 |
| 当前方向 | 等喵呜双模式输出就绪 → 开 P-2 V3 输出 | 默默 |

## 待办

- [ ] 🔄 C-3/C-4/C-5 排期和 PsiGraphEngine 同步 — 默默已确认过，但记忆未同步，等默默告诉结论
- [ ] ⏳ 模型特性标记 (ModelProfile) — 排期 5/29，喵呜已认领
- [ ] ⏳ CallIndex 迁移 — 代码已合入 main (78ea679)，SQLite 部分迁入 common 排期 5/30~5/31
- [ ] ⏳ 等喵呜双模式输出（C-3 SchemaVersion / C-4 SystemPrompt 双模板 / C-5 Normalizer V3）就绪
- [ ] ⏳ 新输出就绪后跑端到端基准测试
