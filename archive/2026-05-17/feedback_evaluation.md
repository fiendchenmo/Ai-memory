---
name: feedback-evaluation
description: "How to approach architecture evaluation, benchmark testing, and code review tasks"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2a73396e-68e1-4eb5-985c-57239353d3d3
---

When the user asks for evaluation or assessment of reports/code/architecture:

**Do**:
- Be strict and detailed - point out specific flaws with evidence
- Distinguish synthetic vs real-world test data explicitly
- Validate assumptions before basing conclusions on them (e.g., check config files before assuming defaults)
- Include concrete numbers, tables, and comparisons
- Call out what's missing, not just what's present
- Rate each dimension separately with clear rationale

**Don't**:
- Give generic praise without specifics
- Assume default configurations without verification
- Overlook missing edge cases or unvalidated preconditions

**Why**: The user is a senior architect who values precision and can detect when analysis is superficial. They correct errors directly and expect adjustments to be made rather than debated.

**How to apply**: In any code review, architecture assessment, or benchmark report, lead with what's wrong or missing, not what's right. Use scoring rubrics. Verify assumptions with code/config checks.
