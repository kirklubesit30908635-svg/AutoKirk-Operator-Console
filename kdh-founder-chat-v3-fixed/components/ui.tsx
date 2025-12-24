import React from "react";

export function Card({ children }: { children: React.ReactNode }) {
  return (
    <div style={{
      background: "#0f1620",
      border: "1px solid #1f2a37",
      borderRadius: 16,
      padding: 14
    }}>
      {children}
    </div>
  );
}

export function Button(props: React.ButtonHTMLAttributes<HTMLButtonElement> & { variant?: "primary" | "ghost" | "danger" }) {
  const { variant = "primary", style, ...rest } = props;
  const base: React.CSSProperties = {
    borderRadius: 12,
    padding: "10px 12px",
    border: "1px solid #223042",
    background: variant === "primary" ? "#111827" : "transparent",
    color: "#e6edf3",
    cursor: "pointer"
  };
  if (variant === "danger") {
    base.border = "1px solid #7f1d1d";
    base.background = "#1f0b0b";
  }
  return <button {...rest} style={{ ...base, ...style }} />;
}

export function Input(props: React.InputHTMLAttributes<HTMLInputElement>) {
  return (
    <input
      {...props}
      style={{
        width: "100%",
        borderRadius: 12,
        padding: "10px 12px",
        border: "1px solid #223042",
        background: "#0b0f14",
        color: "#e6edf3"
      }}
    />
  );
}

export function TextArea(props: React.TextareaHTMLAttributes<HTMLTextAreaElement>) {
  return (
    <textarea
      {...props}
      style={{
        width: "100%",
        borderRadius: 12,
        padding: "10px 12px",
        border: "1px solid #223042",
        background: "#0b0f14",
        color: "#e6edf3",
        resize: "vertical",
        minHeight: 90
      }}
    />
  );
}
