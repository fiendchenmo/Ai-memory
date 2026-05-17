# One-time setup: git remote + Task Scheduler
# Run: powershell.exe -ExecutionPolicy Bypass -File setup.ps1

$ErrorActionPreference = "Stop"
$RepoRoot = "C:\Users\dj\long-term-memory"
$RemoteUrl = "https://github.com/fiendchenmo/Ai-memory"

Push-Location $RepoRoot

# --- 1. Add remote and push ---
Write-Host "=== Setting up git remote ==="
$remotes = git remote 2>$null
if ($remotes -notcontains "origin") {
    git remote add origin $RemoteUrl
    Write-Host "Remote 'origin' added: $RemoteUrl"
} else {
    Write-Host "Remote 'origin' already exists, updating URL..."
    git remote set-url origin $RemoteUrl
}

git push -u origin master
Write-Host "Git push done."

# --- 2. Update sync script with remote ---
Write-Host "=== Updating sync-memory.ps1 remote ==="
$scriptPath = Join-Path $RepoRoot "sync-memory.ps1"
$content = Get-Content $scriptPath -Raw

# Find the GitRemote default parameter and update it
$newContent = $content -replace '(?<=\[string\]\$GitRemote = ")[^"]*', $RemoteUrl
Set-Content -Path $scriptPath -Value $newContent -Encoding utf8
Write-Host "Remote URL written to sync-memory.ps1."

# --- 3. Create Task Scheduler ---
Write-Host "=== Creating scheduled task ==="
$taskName = "LongTermMemorySync"
$existing = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existing) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$RepoRoot\sync-memory.ps1`""
$trigger = New-ScheduledTaskTrigger -Daily -At 22:00
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Force

Write-Host "Scheduled task '$taskName' created: daily at 22:00" -ForegroundColor Green

Pop-Location

Write-Host "`n=== Setup complete ===" -ForegroundColor Green
Write-Host "Memories will now sync nightly at 22:00 and push to GitHub."
