import { NextResponse } from "next/server";
import { stripe } from "@/lib/stripe/server";

export async function POST(req: Request) {
  try {
    const { customerEmail } = await req.json();

    const appUrl = process.env.NEXT_PUBLIC_APP_URL!;
    const priceId = process.env.STRIPE_PRICE_ID!;

    const session = await stripe.checkout.sessions.create({
      mode: "subscription",
      payment_method_types: ["card"],
      customer_email: customerEmail || undefined,
      line_items: [{ price: priceId, quantity: 1 }],
      success_url: `${appUrl}/account?checkout=success`,
      cancel_url: `${appUrl}/pricing?checkout=cancel`,
    });

    return NextResponse.json({ url: session.url });
  } catch (err: any) {
    return NextResponse.json(
      { error: err?.message ?? "Checkout creation failed" },
      { status: 400 }
    );
  }
}
