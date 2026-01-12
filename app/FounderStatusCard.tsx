"use client";

import { useEffect, useState } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase/browser";

type State = {
  loading: boolean;
  error?: string;
  email?: string | null;
  role?: string | null;
  status?: string | null;
};

export default function FounderStatusCard() {
  const supabase = createSupabaseBrowserClient();
  const [state, setState] = useState<State>({ loading: true });

  useEffect(() => {
    (async () => {
      const {
        data: { user },
      } = await supabase.auth.getUser();

      if (!user) {
        setState({ loading: false, error: "Not signed in" });
        return;
      }

      const { data } = await supabase
        .from("founder.founder_profiles")
        .select("role,status")
        .eq("user_id", user.id)
        .single();

      setState({ loading: false, email: user.email, ...data });
    })();
  }, [supabase]);

  if (state.loading) return <div>Checking system…</div>;
  if (state.error) return <div style={{ color: "red" }}>{state.error}</div>;

  return (
    <div style={{ border: "1px solid #333", padding: 16, borderRadius: 8 }}>
      <h3>System Status</h3>
      <p>
        <strong>User:</strong> {state.email}
      </p>
      <p>
        <strong>Role:</strong> {state.role}
      </p>
      <p>
        <strong>Status:</strong> {state.status}
      </p>
      <p style={{ color: "green" }}>
        <strong>Connection:</strong> ACTIVE
      </p>
    </div>
  );
}
