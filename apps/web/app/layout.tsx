import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Ebbli Community OS",
  description: "Open-source infrastructure for trusted, mobile-first communities.",
};

export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
