import { createRouteHandlerClient } from "@supabase/auth-helpers-nextjs";
import { cookies } from "next/headers";

export async function GET(req: Request) {
  const { searchParams } = new URL(req.url);
  const thread_id = searchParams.get("thread_id");

  if (!thread_id) {
    return new Response("thread_id required", { status: 400 });
  }

  const supabase = createRouteHandlerClient({ cookies });

  const { data, error } = await supabase
    .schema("founder")
    .from("messages")
    .select("*")
    .eq("thread_id", thread_id)
    .order("created_at", { ascending: true });

  if (error) {
    return new Response(error.message, { status: 500 });
  }

  return Response.json({ ok: true, data });
}

export async function POST(req: Request) {
  const body = await req.json();
  const { thread_id, content, role = "user", meta = {} } = body;

  if (!thread_id || !content) {
    return new Response("thread_id and content required", { status: 400 });
  }

  const supabase = createRouteHandlerClient({ cookies });

  const { error } = await supabase
    .schema("founder")
    .from("messages")
    .insert({
      thread_id,
      content,
      role,
      meta
    });

  if (error) {
    return new Response(error.message, { status: 500 });
  }

  return Response.json({ ok: true });
}
