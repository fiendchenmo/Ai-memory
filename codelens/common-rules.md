# Common 模块规则

## 包名
`com.codelens.common.*`

## 版本号
- 重构完成首版: `v1.0.0-rc1`
- 改 Schema (JSON_SCHEMA/数据结构) → 升 minor
- 改接口 (public API/抽象类签名) → 升 major
- 修 bug (实现错误/边界条件) → 升 patch

## 三方联动工作流
多方架构审查 → 默默合并报告 → 按治理边界认领 → 需拍板提交默默
