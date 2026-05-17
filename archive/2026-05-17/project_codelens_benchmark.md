---
name: project-codelens-benchmark
description: "CodeLens CLI benchmark findings - XLARGE file counter-intuitive L1 performance, API latency analysis"
metadata: 
  node_type: memory
  type: project
  originSessionId: 2a73396e-68e1-4eb5-985c-57239353d3d3
---

**CodeLens CLI Benchmark (2026-05-15)**

Key findings from production-grade benchmark testing:

- **XLARGE files (500+ lines) outperform MEDIUM files (60-100 lines) in L1 pass rate**: 80-95% vs 28-78%. Counter-intuitive but consistent across both synthetic and real-world test files.
- **Synthetic test files give misleadingly optimistic results**: ProcurementApprovalServiceImpl (synthetic) got 100% L1, but SysUserServiceImpl (real RuoYi-Cloud) got only 84.6%.
- **EvidenceValidator ±2 line search window is too narrow**: Dependencies偏差 3-15 lines common, especially static imports. ±5 would be more appropriate.
- **API latency is inference-bound, not network-bound**: Pure network latency only ~0.3s; 65-108s total is 100% LLM inference time for 4000-8000 token generation.
- **L1 overall pass rate**: 89.9% across 9 files (138 checkpoints, 124 passed).

**Why**: Understanding these patterns helps set realistic expectations for LLM-based code analysis tools and guides improvements to the validation pipeline.

**How to apply**: When evaluating CodeLens results, expect L1 pass rates of 80-95% for real project files. Treat synthetic test results as upper bounds, not baselines. Recommend widening EvidenceValidator search window from ±2 to ±5.
