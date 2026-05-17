<#
.SYNOPSIS
    Sync Claude Code memories to long-term git repo.
    Designed to run via Windows Task Scheduler daily at 22:00.
#>

param(
    [string]$MemorySource = "$env:USERPROFILE\.claude\projects\C--Users-dj\memory",
    [string]$RepoRoot = "$env:USERPROFILE\long-term-memory",
    [string]$GitRemote = ""
)

$ErrorActionPreference = "Stop"
$Date = Get-Date -Format "yyyy-MM-dd"
$LogFile = Join-Path $RepoRoot "sync.log"

function Log {
    param([string]$Msg)
    $Time = Get-Date -Format "HH:mm:ss"
    "$Time | $Msg" | Out-File -FilePath $LogFile -Append -Encoding utf8
    Write-Host "$Time | $Msg"
}

Log "=== Memory sync started: $Date ==="

# 1. Check source directory
if (-not (Test-Path $MemorySource)) {
    Log "ERROR: Source not found: $MemorySource"
    exit 1
}

# 2. Create today's archive folder
$ArchiveDir = Join-Path (Join-Path $RepoRoot "archive") $Date
if (-not (Test-Path $ArchiveDir)) {
    New-Item -ItemType Directory -Path $ArchiveDir -Force | Out-Null
    Log "Created archive folder: archive/$Date"
}

# 3. Copy memory files (dedup by content hash)
$SourceFiles = Get-ChildItem -Path $MemorySource -Filter "*.md" | Sort-Object LastWriteTime -Descending
$CopiedCount = 0
$SkippedCount = 0

foreach ($file in $SourceFiles) {
    $destPath = Join-Path $ArchiveDir $file.Name
    if (Test-Path $destPath) {
        $srcHash = (Get-FileHash $file.FullName -Algorithm MD5).Hash
        $dstHash = (Get-FileHash $destPath -Algorithm MD5).Hash
        if ($srcHash -eq $dstHash) {
            $SkippedCount++
            continue
        }
    }
    Copy-Item -Path $file.FullName -Destination $destPath -Force
    $CopiedCount++
}

Log "Files: $CopiedCount new/updated, $SkippedCount skipped"

# 4. Copy MEMORY.md snapshot if exists
$SourceIndex = Join-Path $MemorySource "MEMORY.md"
if (Test-Path $SourceIndex) {
    Copy-Item -Path $SourceIndex -Destination (Join-Path $ArchiveDir "MEMORY.md") -Force
    Log "MEMORY.md snapshot saved"
}

# 5. Write archive INDEX.md
$archiveIndex = Join-Path $ArchiveDir "INDEX.md"
$fileList = $SourceFiles.Name | ForEach-Object { "- $_" }
@"
# Archive: $Date

## Files
$($fileList -join "`n")

Synced at: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@ | Out-File -FilePath $archiveIndex -Encoding utf8

# 6. Update master MEMORY_INDEX.md
$MasterIndex = Join-Path $RepoRoot "MEMORY_INDEX.md"
$AllArchives = Get-ChildItem -Path (Join-Path $RepoRoot "archive") -Directory | Sort-Object Name -Descending

$indexLines = @(
    "# Long-Term Memory Master Index",
    "",
    "Last updated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')",
    "",
    "## Archive Timeline (newest first)",
    "",
    "| Date | Files | Summary |",
    "|------|-------|---------|"
)

foreach ($dir in $AllArchives) {
    $fileCount = (Get-ChildItem -Path $dir.FullName -Filter "*.md" | Where-Object { $_.Name -ne "INDEX.md" }).Count
    $indexLines += "| $($dir.Name) | $fileCount | - |"
}

$indexLines += ""
$indexLines += "Source: $env:USERPROFILE\.claude\projects\C--Users-dj\memory\"
$indexLines -join "`n" | Out-File -FilePath $MasterIndex -Encoding utf8
Log "Master index updated ($($AllArchives.Count) archives)"

# 7. Git operations
try {
    Push-Location $RepoRoot
    & git add -A 2>&1 | ForEach-Object { Log $_ }

    $status = & git status --porcelain
    if ($status) {
        & git commit -m "memory archive: $Date" --allow-empty 2>&1 | ForEach-Object { Log $_ }
        Log "Git commit done"

        if ($GitRemote -ne "") {
            $remotes = & git remote 2>$null
            if (-not $remotes) {
                & git remote add origin $GitRemote 2>&1 | ForEach-Object { Log $_ }
                Log "Remote added: $GitRemote"
            }
            & git push -u origin master 2>&1 | ForEach-Object { Log $_ }
            Log "Git push done"
        }
    } else {
        Log "No changes, commit skipped"
    }
    Pop-Location
}
catch {
    Log "Git operation failed: $_"
}

Log "=== Memory sync completed: $Date ==="
Log ""
