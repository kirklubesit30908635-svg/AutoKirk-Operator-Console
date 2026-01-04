import "./globals.css";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Autokirk Operator Console",
  description: "The governed operations console where every action is explicit, auditable, and consent-driven."
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="antialiased">{children}</body>
    </html>
  );
}
