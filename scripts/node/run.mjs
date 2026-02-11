import fs from "node:fs";
import path from "node:path";
import process from "node:process";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const REPO_ROOT = path.resolve(__dirname, "..", "..");
const APP_DIR = path.join(REPO_ROOT, "autokirk-operator-console");
const ENV_PATH = path.join(APP_DIR, ".env.local");

function log(s){ console.log(s); }
function ok(s){ console.log(`OK: ${s}`); }
function info(s){ console.log(`INFO: ${s}`); }
function fail(s){ console.error(`FAIL: ${s}`); process.exitCode = 1; }

function loadEnvLocal() {
  if (!fs.existsSync(ENV_PATH)) {
    info(`Env file not found: ${ENV_PATH}`);
    return;
  }
  const text = fs.readFileSync(ENV_PATH, "utf8");
  for (const lineRaw of text.split(/\r?\n/)) {
    const line = lineRaw.trim();
    if (!line || line.startsWith("#")) continue;
    const i = line.indexOf("=");
    if (i === -1) continue;
    const k = line.slice(0, i).trim();
    const v = line.slice(i + 1).trim();
    if (!process.env[k]) process.env[k] = v;
  }
  ok(`Loaded env file: ${ENV_PATH}`);
}

async function doctor() {
  log("AutoKirk Orchestrator — run.mjs doctor");
  log(`Node: ${process.version}`);
  log("");

  loadEnvLocal();
  log("");

  const required = ["NEXT_PUBLIC_SUPABASE_URL", "NEXT_PUBLIC_SUPABASE_ANON_KEY"];
  for (const k of required) {
    if (!process.env[k]) fail(`Missing required env: ${k}`);
    else ok(`Env ${k}: present`);
  }
  if (process.exitCode) {
    log("");
    info("Fix: open autokirk-operator-console/.env.local and set required vars.");
    return;
  }

  let createClient;
  try {
    ({ createClient } = await import("@supabase/supabase-js"));
    ok("Loaded @supabase/supabase-js");
  } catch {
    fail("Missing @supabase/supabase-js in app. Fix: cd autokirk-operator-console && npm i @supabase/supabase-js");
    return;
  }

  const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY,
    { auth: { persistSession: false, autoRefreshToken: false } }
  );

  const targets = [
    { schema: "tucker", view: "v_current_open_obligations" },
    { schema: "tucker", view: "v_promises_state" },
  ];

  for (const t of targets) {
    const { data, error } = await supabase.schema(t.schema).from(t.view).select("*").limit(1);
    if (error) fail(`Read check failed: ${t.schema}.${t.view} → ${error.message}`);
    else ok(`Read check: ${t.schema}.${t.view} → ok (${Array.isArray(data) ? data.length : 0} rows)`);
  }
}

async function main() {
  const cmd = process.argv[2] || "doctor";
  if (cmd === "doctor") await doctor();
  else fail(`Unknown command: ${cmd}`);

  if (process.exitCode) process.exit(process.exitCode);
}

main().catch((e) => {
  console.error("FAIL: orchestrator crashed");
  console.error(e);
  process.exit(1);
});
