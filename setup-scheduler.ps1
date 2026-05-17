# Run this script as Administrator to set up the nightly sync task
# Or run: powershell.exe -ExecutionPolicy Bypass -File setup-scheduler.ps1

$taskName = "LongTermMemorySync"
$scriptPath = "C:\Users\dj\long-term-memory\sync-memory.ps1"
$action = "powershell.exe -ExecutionPolicy Bypass -File `"$scriptPath`""

# Check if task already exists
$existing = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host "Task '$taskName' already exists. Removing and recreating..."
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

# Create the task
$trigger = New-ScheduledTaskTrigger -Daily -At 22:00
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

Register-ScheduledTask -TaskName $taskName `
    -Action (New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptPath`"") `
    -Trigger $trigger `
    -Principal $principal `
    -Settings $settings `
    -Force

if ($?) {
    Write-Host "Scheduled task '$taskName' created: daily at 22:00" -ForegroundColor Green
} else {
    Write-Host "Failed to create scheduled task." -ForegroundColor Red
}
