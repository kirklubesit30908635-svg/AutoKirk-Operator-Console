# ops/mcp-v0-tooling.ps1
# AutoKirk MCP v0 Tooling Installer
# Replays Tool #1 and Tool #2 file surfaces deterministically.

Write-Host "=== AutoKirk MCP v0 Tooling Install ==="

# --- Tool #1: read_state ---
$readPath = "src\app\api\mcp\read-state"
New-Item -ItemType Directory -Force -Path $readPath | Out-Null

@"
import { NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

export async function GET() {
  const supabase = createClient(
    process.env.SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!
  );

  const { data, error } = await supabase
    .from("v_founder_state")
    .select("state, updated_at")
    .eq("key", "founder_state")
    .single();

  if (error) {
    return NextResponse.json(
      { ok: false, error: error.message },
      { status: 500 }
    );
  }

  return NextResponse.json({
    ok: true,
    founder_state: data.state,
    updated_at: data.updated_at,
  });
}
"@ | Set-Content -Encoding UTF8 "$readPath\route.ts"

Write-Host "Tool #1 installed: read_state"

# --- Tool #2: propose scaffold ---
$propPath = "src\app\api\mcp\propose"
New-Item -ItemType Directory -Force -Path $propPath | Out-Null

@"
import { NextResponse } from "next/server";
import { createClient } from "@supabase/supabase-js";

export async function POST(req: Request) {
  return NextResponse.json({
    ok: false,
    note: "Tool #2 propose is scaffolded. RPC wiring resumes next session."
  });
}
"@ | Set-Content -Encoding UTF8 "$propPath\route.ts"

Write-Host "Tool #2 scaffold installed: propose"

Write-Host "=== MCP v0 tooling install complete ==="
