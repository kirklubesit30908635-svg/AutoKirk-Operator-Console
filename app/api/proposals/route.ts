import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({
    proposals: [
      {
        id: "P-00112",
        title: "Rotate public API key reference",
        risk: "LOW",
        summary: "Client-only env update · No secret exposure"
      },
      {
        id: "P-00094",
        title: "Change system safety state",
        risk: "MEDIUM",
        summary: "Set arm_state → DISARMED · Governed execution with proof"
      }
    ]
  });
}
