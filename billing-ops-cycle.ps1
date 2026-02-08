param(
  [string]$SupabaseUrl = $env:SUPABASE_URL,
  [string]$ServiceKey = $env:SUPABASE_SERVICE_ROLE_KEY
)

if (-not $SupabaseUrl) {
  Write-Error "[AutoKirk] SUPABASE_URL not set"
  exit 1
}

if (-not $ServiceKey) {
  Write-Error "[AutoKirk] SUPABASE_SERVICE_ROLE_KEY not set"
  exit 1
}

$headers = @{
  "apikey"        = $ServiceKey
  "Authorization" = "Bearer $ServiceKey"
  "Content-Type"  = "application/json"
}

Write-Host "[AutoKirk] Billing Ops cycle START $(Get-Date -Format o)"

try {
  Invoke-RestMethod `
    -Method Post `
    -Uri "$SupabaseUrl/rest/v1/rpc/run_billing_ops_cycle" `
    -Headers $headers `
    -Body '{}' `
    -TimeoutSec 30

  Write-Host "[AutoKirk] Billing Ops cycle COMPLETE $(Get-Date -Format o)"
}
catch {
  Write-Error "[AutoKirk] Billing Ops cycle FAILED"
  Write-Error $_
  exit 1
}
