import "./globals.css";

export const metadata = {
  title: "KDH Founder Chat",
  description: "Founder-only command surface for Kirk Digital Holdings."
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
