"use client";

import { useEffect, useMemo, useState } from "react";
import { supabaseBrowser } from "../../lib/supabaseBrowser";

type Proof = {
  uid: string | null;
  public_is_founder: boolean | null;
  ak_is_founder: boolean | null;
  task_templates_readable: boolean;
  task_templates_error: string | null;
  rpc_public_error: string | null;
  rpc_ak_error: string | null;
};

export default function FounderProofPage() {
  const supabase = useMemo(() => supabaseBrowser(), []);
  const [proof, setProof] = useState<Proof | null>(null);
  const [status, setStatus] = useState("Running proof...");

  useEffect(() => {
    (async () => {
      const { data: u, error: uerr } = await supabase.auth.getUser();
      const uid = u?.user?.id ?? null;

      if (uerr) {
        setProof({
          uid,
          public_is_founder: null,
          ak_is_founder: null,
          task_templates_readable: false,
          task_templates_error: uerr.message,
          rpc_public_error: null,
          rpc_ak_error: null,
        });
        setStatus("Auth error.");
        return;
      }

      const pub = await supabase.rpc("is_founder");
      const ak = await supabase.rpc("is_founder", {}, { schema: "ak" } as any);
      const tt = await supabase.from("task_templates").select("id").limit(1);

      setProof({
        uid,
        public_is_founder: pub.data ?? null,
        ak_is_founder: ak.data ?? null,
        task_templates_readable: !tt.error,
        task_templates_error: tt.error?.message ?? null,
        rpc_public_error: pub.error?.message ?? null,
        rpc_ak_error: ak.error?.message ?? null,
      });

      setStatus("Proof complete.");
    })();
  }, [supabase]);

  return (
    <main style={{ maxWidth: 760, margin: "48px auto", padding: 16 }}>
      <h1>Founder Proof</h1>
      <div>Status: {status}</div>
      {proof && <pre>{JSON.stringify(proof, null, 2)}</pre>}
    </main>
  );
}