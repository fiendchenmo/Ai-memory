---
name: reference-api-keys
description: "API key locations and project paths for DeepSeek, Coze, and other services"
metadata: 
  node_type: memory
  type: reference
  originSessionId: 2a73396e-68e1-4eb5-985c-57239353d3d3
---

**DeepSeek API Key** (for CodeLens CLI):
- Env var: 
- Base URL: `https://api.deepseek.com`
- Also set as `ANTHROPIC_BASE_URL` and `ANTHROPIC_MODEL=deepseek-chat`

**Coze Chat**:
- Project: `//wsl.localhost/Ubuntu/home/dj/coze-chat/`
- Token in `.env` file: 
- Backend: `backend.py` (Python SSE streaming server)
- Host: `5tkfcxq3jf.coze.site`, path: `/stream_run`
