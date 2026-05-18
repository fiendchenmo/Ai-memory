# Coze 聊天项目

**2026-05-17 归档**

- 项目路径: `~/coze-chat/`
- 技术栈: Python stdlib 后端 + 自包含前端(手机自适应)
- Coze API: POST https://5tkfcxq3jf.coze.site/stream_run (SSE流式)
- session_id: xfw6O355JY-czAga_VCze
- project_id: 7639233788865970182
- Token 放在 `.env`, 启动命令: `python3 backend.py` → :8080
- 手机访问: http://192.168.0.3:8080
- WSL2端口转发: netsh不稳定，可靠方案→ `%USERPROFILE%\\.wslconfig` 设 `networkingMode=mirrored` + `firewall=false` 后重启 WSL
- 电脑 192.168.0.3, 手机 192.168.0.2
- 镜像模式下 8080 可能被 Windows 占需换端口
