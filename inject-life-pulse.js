const fs = require("fs");

// 1) Write FounderStatusCard
const card = `"use client";
import { useEffect, useState } from "react";
import { createSupabaseBrowserClient } from "@/lib/supabase/browser";

export default function FounderStatusCard() {
  const supabase = createSupabaseBrowserClient();
  const [state, setState] = useState({ loading: true });

  useEffect(() => {
    (async () => {
      const { data: { user } } = await supabase.auth.getUser();
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
  }, []);

  if (state.loading) return <div>Checking system…</div>;
  if (state.error) return <div style={{color:"red"}}>{state.error}</div>;

  return (
    <div style={{border:"1px solid #333", padding:16, borderRadius:8}}>
      <h3>System Status</h3>
      <p><strong>User:</strong> {state.email}</p>
      <p><strong>Role:</strong> {state.role}</p>
      <p><strong>Status:</strong> {state.status}</p>
      <p style={{color:"green"}}><strong>Connection:</strong> ACTIVE</p>
    </div>
  );
}
`;

fs.writeFileSync("app/FounderStatusCard.tsx", card);

// 2) Patch index.tsx safely
let index = fs.readFileSync("index.tsx", "utf8");

if (!index.includes("FounderStatusCard")) {
  index = `import FounderStatusCard from "./FounderStatusCard";\n` + index;
  index = index.replace(/(<[^>]+>)/, `$1\n<FounderStatusCard />`);
  fs.writeFileSync("index.tsx", index);
}

console.log("Life Pulse v1 injected successfully.");
