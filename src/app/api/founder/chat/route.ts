import { NextResponse } from "next/server";
import OpenAI from "openai";
import { FOUNDER_IDS } from "../../../../lib/founder";

export async function POST(req: Request) {
  const { founderId, message } = await req.json();

  if (!FOUNDER_IDS.has(founderId)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 403 });
  }

  const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY!,
  });

  const completion = await openai.chat.completions.create({
    model: process.env.OPENAI_MODEL || "gpt-4o-mini",
    messages: [
      { role: "system", content: "Founder Control AI. Authority-bound." },
      { role: "user", content: message },
    ],
  });

  return NextResponse.json({
    reply: completion.choices[0].message.content,
  });
}
