import { redirect } from "next/navigation";
import Link from "next/link";
import { createServerSupabaseClient } from "@/lib/supabase/server";

export const dynamic = "force-dynamic";
export const revalidate = 0;

export default async function ThreadPage({
  params,
}: {
  params: { threadId: string };
}) {
  const supabase = await createServerSupabaseClient();
  const { data, error } = await supabase.auth.getUser();

  if (error || !data?.user) redirect("/login");

  return (
    <main style={{ padding: 24 }}>
      <Link href="/chat">← Back</Link>
      <h1 style={{ marginTop: 16 }}>Thread</h1>
      <p>threadId: {params.threadId}</p>
      <p>user: {data.user.id}</p>
    </main>
  );
}
