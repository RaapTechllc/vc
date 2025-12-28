# PowerShell script to set ANTHROPIC_OAUTH_TOKEN as a permanent user environment variable
# Usage: .\set-oauth-token.ps1 "your-token-here"

param(
    [Parameter(Mandatory=$true)]
    [string]$Token
)

# Set as user environment variable (persists across sessions)
[Environment]::SetEnvironmentVariable("ANTHROPIC_OAUTH_TOKEN", $Token, "User")

Write-Host "✓ ANTHROPIC_OAUTH_TOKEN set successfully!" -ForegroundColor Green
Write-Host "  Token: $($Token.Substring(0, 20))..." -ForegroundColor Gray
Write-Host ""
Write-Host "⚠️  Restart your terminal for the change to take effect" -ForegroundColor Yellow
Write-Host ""
Write-Host "To verify after restart:" -ForegroundColor Cyan
Write-Host '  echo $env:ANTHROPIC_OAUTH_TOKEN' -ForegroundColor Gray
