param(
  [switch]$CI
)

$ErrorActionPreference = "Stop"

Write-Host "AutoKirk Dev Harness — Doctor (PowerShell wrapper)" -ForegroundColor Cyan
Write-Host "Repo: $(Get-Location)"
Write-Host ""

# Ensure we're at repo root (best-effort)
if (-not (Test-Path ".git")) {
  Write-Host "WARN: .git not found here. Are you at repo root?" -ForegroundColor Yellow
}

# Show git state (non-fatal)
try {
  $branch = (git rev-parse --abbrev-ref HEAD).Trim()
  $sha = (git rev-parse --short HEAD).Trim()
  Write-Host "Git: $branch @ $sha"
} catch {
  Write-Host "WARN: git not available or not a repo" -ForegroundColor Yellow
}

Write-Host ""

# Move into Next.js app
$AppDir = Join-Path (Get-Location) "autokirk-operator-console"
if (-not (Test-Path $AppDir)) {
  Write-Error "Next app folder not found: $AppDir"
}

Push-Location $AppDir

try {
  Write-Host "Running node doctor..." -ForegroundColor Cyan
  node ..\scripts\node\doctor.mjs
  $code = $LASTEXITCODE
  if ($code -ne 0) {
    Write-Host ""
    Write-Host "Doctor wrapper: FAIL (exit $code)" -ForegroundColor Red
    exit $code
  }

  Write-Host ""
  Write-Host "Doctor wrapper: PASS" -ForegroundColor Green
} finally {
  Pop-Location
}
