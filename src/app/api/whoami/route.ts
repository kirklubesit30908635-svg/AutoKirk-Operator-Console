import { NextResponse } from "next/server";
import { createSupabaseServer } from "@/lib/supabaseServer";

export async function GET() {
  const supabase = await createSupabaseServer();
  const { data } = await supabase.auth.getUser();
  return NextResponse.json({ user: data.user ?? null });
}
