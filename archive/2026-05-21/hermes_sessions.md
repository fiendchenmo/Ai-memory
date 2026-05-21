# Hermes 会话记忆 2026-05-21

## 工作内容

- **A组 DeepSeek v4-flash 基准测试完成** — 全量12文件跑完，L1通过率100%（12/12），行号精确率100%，FinalScore 77.2/100
- **B组 DeepSeek v4-Pro 测试** — 只跑了T1（3x慢+卡IDE+质量无明显提升），结论：放弃全量，Pro只适合单文件攻坚
- **基准测试规范v2.0更新** — 12个测试文件定稿、多模型方案（A组flash全量→B组pro→C组千问抽样→D组Kimi→E组豆包）、禁用缓存、简化执行流程
- **C组 千问 qwen-plus 抽样测试** — 抽取T1/T2/T6/T11四个文件完成测试，结果分析：L1通过率100%，但输出比Flash精简（Deps数量少、项数少），Flash更优
- **豆包 doubao-pro-32k 尝试** — 未开通权限（InvalidEndpointOrModel.Not Found），建议改用 `doubao-seed-2-0-lite-260215`
- **ACTIVE.md 更新** — 当前阶段标记为基准测试进行中，A组Flash已完成
- **记忆同步** — 基准测试进度写入持久记忆

## 关键决策

- **B组 Pro 放弃全量基准测试** → 3x慢+卡IDE，只适合单文件架构攻坚
- **千问 qwen-plus 对比结论** → L1通过率与Flash持平（100%），但输出项数和丰富度不如Flash，Flash更优
- **豆包模型切换** → doubao-pro-32k 未开通权限，改用 `doubao-seed-2-0-lite-260215`
- **如果豆包也无明显差异** → 基准测试收尾，不再继续跑更多模型

## 待办

- [ ] 豆包 doubao-seed-2-0-lite-260215 抽样测试（T1/T2/T6/T11）
- [ ] 如趋势已明显，基准测试收尾，出完整三模型对比报告
- [ ] 测试完成后删除 CodeLens.txt（含 API Key）
- [ ] Phase 2 排期（CallIndex迁移、温度锁定等）
