/**
 * AutoKirk Dev Harness — Doctor v1.1
 * - Loads .env.local explicitly (so it works outside Next.js)
 * - No secrets printed
 * - Read-only checks only
 * - Exits non-zero on FAIL (CI-enforceable)
 */

import fs from "node:fs";
import path from "node:path";
import process from "node:process";

// Load env files explicitly
function loadEnv() {
  // doctor.mjs lives at: <repo>/scripts/node/doctor.mjs
  // Next app env file lives at: <repo>/autokirk-operator-console/.env.local
  const repoRoot = path.resolve(path.dirname(new URL(import.meta.url).pathname), "..", "..");
  const envPath = path.join(repoRoot, "autokirk-operator-console", ".env.local");

  try {
    const dotenv = await import("dotenv");
    if (fs.existsSync(envPath)) {
      dotenv.config({ path: envPath });
      console.log(`OK: Loaded env file: ${envPath}`);
    } else {
      console.log(`INFO: Env file not found: ${envPath}`);
    }
  } catch (e) {
    console.error("FAIL: dotenv not installed. Run: cd autokirk-operator-console && npm i -D dotenv");
    process.exit(1);
  }
}

const REQUIRED_ENV = [
  "NEXT_PUBLIC_SUPABASE_URL",
  "NEXT_PUBLIC_SUPABASE_ANON_KEY",
];

const OPTIONAL_ENV = [
  "SUPABASE_SERVICE_ROLE_KEY",
];

function fail(msg) {
  console.error(`FAIL: ${msg}`);
  process.exitCode = 1;
}

function ok(msg) {
  console.log(`OK: ${msg}`);
}

function maskPresence(v) {
  return v ? "present" : "missing";
}

async function main() {
  console.log("AutoKirk Doctor v1.1");
  console.log(`Node: ${process.version}`);
  console.log("");

  await loadEnv();
  console.log("");

  // 1) Env checks (presence only)
  for (const k of REQUIRED_ENV) {
    if (!process.env[k]) fail(`Missing required env: ${k}`);
    else ok(`Env ${k}: present`);
  }
  for (const k of OPTIONAL_ENV) {
    console.log(`INFO: Env ${k}: ${maskPresence(process.env[k])}`);
  }

  if (process.exitCode) {
    console.log("");
    console.log("Doctor halted due to missing required env.");
    return;
  }

  // 2) Supabase connectivity + read-only view checks
  let createClient;
  try {
    ({ createClient } = await import("@supabase/supabase-js"));
    ok("Loaded @supabase/supabase-js");
  } catch (e) {
    fail("Missing dependency @supabase/supabase-js. Run: npm i @supabase/supabase-js");
    return;
  }

  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const anon = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  const supabase = createClient(url, anon, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  const targets = [
    { schema: "tucker", view: "v_current_open_obligations", limit: 1 },
    { schema: "tucker", view: "v_promises_state", limit: 1 },
  ];

  for (const t of targets) {
    const { data, error } = await supabase
      .schema(t.schema)
      .from(t.view)
      .select("*")
      .limit(t.limit);

    if (error) {
      fail(`Read check failed: ${t.schema}.${t.view} → ${error.message}`);
    } else {
      ok(`Read check: ${t.schema}.${t.view} → ok (${Array.isArray(data) ? data.length : 0} rows)`);
    }
  }

  console.log("");
  if (process.exitCode) {
    console.log("Doctor result: FAIL");
    process.exit(process.exitCode);
  } else {
    console.log("Doctor result: PASS");
  }
}

main().catch((e) => {
  console.error("FAIL: Doctor crashed");
  console.error(e);
  process.exit(1);
});
