"use client";

export default function TestReceiptPage() {
  async function issue() {
    const res = await fetch("/api/core/receipts/issue", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        subjectRef: "system:test",
        digest: "sha256:test",
        act: "APPROVE"
      }),
    });
    alert(await res.text());
  }

  return (
    <main style={{ padding: 32 }}>
      <button onClick={issue}>Issue Receipt</button>
    </main>
  );
}
