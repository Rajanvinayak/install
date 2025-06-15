<#
.SYNOPSIS
    Continuously (every 5 seconds) stops all running processes whose executable path ends with “.tmp.exe”.
.DESCRIPTION
    The script enumerates all running processes on the local machine and force-terminates any whose
    executable path matches the regular-expression pattern provided (default: '\.tmp\.exe').
    It repeats this check every 5 seconds until you interrupt it (Ctrl + C).

.NOTES
    Author : ChatGPT (OpenAI o3)
    Updated: 2025-06-15
#>

[CmdletBinding()]
param (
    # Regular-expression pattern used to match the Path property.
    # Default finds any executable that literally ends with ".tmp.exe" (case-insensitive).
    [string]$Pattern = '\.tmp\.exe'
)

while ($true) {
    try {
        Write-Verbose "Searching for processes that match: $Pattern"

        # Get processes; filter out those whose Path is null, then apply regex.
        $targets = Get-Process -ErrorAction SilentlyContinue | Where-Object {
            $_.Path -and $_.Path -match $Pattern
        }

        if ($targets) {
            Write-Host "Stopping $($targets.Count) process(es) whose path matches '$Pattern'..." -ForegroundColor Cyan
            $targets | Stop-Process -Force -ErrorAction Stop
            Write-Host "Successfully stopped all matching processes." -ForegroundColor Green
        } else {
            Write-Host "No running processes found matching pattern '$Pattern'." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Warning "One or more processes could not be stopped: $_"
    }

    Start-Sleep -Seconds 5
}
