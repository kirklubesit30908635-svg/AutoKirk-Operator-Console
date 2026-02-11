param(
  [Parameter(Mandatory=$true)][string]$SUPABASE_URL,
  [Parameter(Mandatory=$true)][string]$SUPABASE_SERVICE_ROLE_KEY
)

$ErrorActionPreference="Stop"

$base = $SUPABASE_URL.TrimEnd("/")
$key  = $SUPABASE_SERVICE_ROLE_KEY

$hdr = @{
  "apikey"        = $key
  "Authorization" = "Bearer $key"
  "Content-Type"  = "application/json"
  "Accept"        = "application/json"
}

function Invoke-Rpc($fn, $body) {
  $url = "$base/rest/v1/rpc/$fn"
  try {
    return Invoke-RestMethod -Method Post -Uri $url -Headers $hdr -Body ($body | ConvertTo-Json -Depth 20)
  } catch {
    $ex = $_.Exception
    Write-Host "=== RPC ERROR ==="
    Write-Host "fn=$fn"
    Write-Host $ex.Message
    if ($ex.Response -and $ex.Response.StatusCode) {
      Write-Host ("Status: " + [int]$ex.Response.StatusCode + " " + $ex.Response.StatusCode)
      try {
        $sr = New-Object System.IO.StreamReader($ex.Response.GetResponseStream())
        $txt = $sr.ReadToEnd()
        Write-Host "Body:"
        Write-Host $txt
      } catch {}
    }
    throw
  }
}

Write-Host "=== FOUNDER DEVOPS PIPELINE V1 :: WRITE INTEGRITY GATE ==="

# deterministic request ids
$ridCreate = [guid]::NewGuid().ToString()
$ridNote   = [guid]::NewGuid().ToString()
$ridClose  = [guid]::NewGuid().ToString()

# 1) create promise
$createRes = Invoke-Rpc "fn_create_promise" @{
  request_id = $ridCreate
  subject_type = "lead"
  source = "ci_pipeline"
  customer_identity = "CI Test Customer"
  closure_required_at = (Get-Date).AddDays(1).ToString("o")
}

# Extract promise id (common patterns)
$promiseId =
  if ($createRes.promise_id) { $createRes.promise_id }
  elseif ($createRes.id) { $createRes.id }
  elseif ($createRes[0].promise_id) { $createRes[0].promise_id }
  elseif ($createRes[0].id) { $createRes[0].id }
  else { $null }

if (-not $promiseId) { throw "FAIL: Could not extract promiseId from fn_create_promise response." }

# 2) add note
Invoke-Rpc "fn_add_note" @{
  request_id = $ridNote
  promise_id = $promiseId
  note_text  = "CI pipeline note"
} | Out-Null

# 3) close promise
Invoke-Rpc "fn_close_promise" @{
  request_id = $ridClose
  promise_id = $promiseId
  outcome    = "lost"
  revenue_amount = $null
  reason_code = "ci_pipeline"
} | Out-Null

# 4) ledger proof (RPC truth surface)
$cCreate = Invoke-Rpc "fn_ledger_count_by_request_id" @{ p_request_id = $ridCreate }
$cNote   = Invoke-Rpc "fn_ledger_count_by_request_id" @{ p_request_id = $ridNote }
$cClose  = Invoke-Rpc "fn_ledger_count_by_request_id" @{ p_request_id = $ridClose }

if ($cCreate -ne 1) { throw "FAIL: ledger count for ridCreate expected 1, got $cCreate" }
if ($cNote   -ne 1) { throw "FAIL: ledger count for ridNote expected 1, got $cNote" }
if ($cClose  -ne 1) { throw "FAIL: ledger count for ridClose expected 1, got $cClose" }

# 5) idempotency stability: replay create request_id should not change count
try {
  Invoke-Rpc "fn_create_promise" @{
    request_id = $ridCreate
    subject_type = "lead"
    source = "ci_pipeline_replay"
    customer_identity = "CI Replay"
    closure_required_at = (Get-Date).AddDays(1).ToString("o")
  } | Out-Null
} catch { }

$cReplay = Invoke-Rpc "fn_ledger_count_by_request_id" @{ p_request_id = $ridCreate }
if ($cReplay -ne 1) { throw "FAIL: idempotency breach. ridCreate count changed to $cReplay" }

Write-Host "PASS: Write integrity + ledger proof + idempotency are enforced."
