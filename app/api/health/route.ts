import { NextResponse } from "next/server";

export async function GET() {
  console.log("health check hit");
  return NextResponse.json({ ok: true, ts: Date.now() });
}
