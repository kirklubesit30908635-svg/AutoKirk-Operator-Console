"use client";

import { useEffect, useState } from "react";
import supabaseBrowser from "../../lib/supabaseBrowser";

export default function ConsolePage() {
  const supabase = supabaseBrowser();
  const [templates, setTemplates] = useState<any[]>([]);
  const [errMsg, setErrMsg] = useState<string | null>(null);

  useEffect(() => {
    (async () => {
      const { data, error } = await supabase
        .from("task_templates")
        .select("id,title,task_type,directive,org_id,created_at")
        .eq("org_id", "11111111-1111-1111-1111-111111111111");

      console.log("[templates] data =", data);
      console.log("[templates] error =", error);

      if (error) {
        setErrMsg(`${error.code ?? ""} ${error.message}`);
        return;
      }
      setTemplates(data ?? []);
    })();
  }, []);

  return (
    <div style={{ padding: 24 }}>
      <h1>Autokirk Command Center (DEBUG)</h1>

      {errMsg && (
        <pre style={{ padding: 12, border: "1px solid red" }}>
          Templates query error: {errMsg}
        </pre>
      )}

      <pre style={{ padding: 12, border: "1px solid #ccc" }}>
        Templates loaded: {templates.length}
      </pre>
    </div>
  );
}
