# Credential 全盘清理 (2026-05-17)

- openclaw skill 泄漏 DeepSeek key → 已修复 (替换为占位符)
- Claude Code long-term-memory git history → 已清 (filter-branch → gc → force push)
- 飞书桥 .env 有敏感凭据但被 .gitignore 排除

## 规则
所有文件不硬编码 API key，只用环境变量。
