# Test OAuth Token Integration
# This script loads .env and runs VC commands to verify OAuth authentication works

Write-Host "🔧 Loading environment from .env..." -ForegroundColor Cyan

# Load .env file
if (Test-Path ".env") {
    Get-Content .env | ForEach-Object {
        if ($_ -match '^([^#][^=]+)=(.*)$') {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            [Environment]::SetEnvironmentVariable($name, $value, "Process")
            Write-Host "  ✓ Set $name" -ForegroundColor Green
        }
    }
} else {
    Write-Host "  ✗ .env file not found!" -ForegroundColor Red
    Write-Host "  Run: cp .env.example .env" -ForegroundColor Yellow
    exit 1
}

# Verify token is set
$token = $env:ANTHROPIC_OAUTH_TOKEN
if (-not $token) {
    Write-Host "  ✗ ANTHROPIC_OAUTH_TOKEN not set in .env" -ForegroundColor Red
    exit 1
}

Write-Host "  ✓ OAuth token loaded: $($token.Substring(0, 20))..." -ForegroundColor Green
Write-Host ""

# Test 1: Basic command (doesn't need AI)
Write-Host "📋 Test 1: Basic VC command (no AI required)" -ForegroundColor Cyan
Write-Host "Running: vc.exe --db .beads/beads.db ready" -ForegroundColor Gray
.\vc.exe --db .beads/beads.db ready
Write-Host ""

# Test 2: REPL (requires AI/OAuth)
Write-Host "🤖 Test 2: REPL with OAuth authentication" -ForegroundColor Cyan
Write-Host "This will test if OAuth token works with Claude API" -ForegroundColor Gray
Write-Host "Type 'exit' or Ctrl+C to exit the REPL" -ForegroundColor Yellow
Write-Host ""
.\vc.exe --db .beads/beads.db repl

Write-Host ""
Write-Host "✅ Testing complete!" -ForegroundColor Green
