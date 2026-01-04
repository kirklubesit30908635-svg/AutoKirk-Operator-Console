import FounderStatusCard from "./FounderStatusCard";
import * as React from "react";

export function Button(props: React.ButtonHTMLAttributes<HTMLButtonElement>
<FounderStatusCard />) {
  const { className = "", ...rest } = props;
  return (
    <button className={`px-3 py-2 rounded border text-sm ${className}`} {...rest} />
  );
}

export function Input(props: React.InputHTMLAttributes<HTMLInputElement>) {
  const { className = "", ...rest } = props;
  return (
    <input className={`px-3 py-2 rounded border text-sm w-full ${className}`} {...rest} />
  );
}

export function Card(props: React.HTMLAttributes<HTMLDivElement>) {
  const { className = "", ...rest } = props;
  return <div className={`rounded border p-4 ${className}`} {...rest} />;
}

export function CardHeader(props: React.HTMLAttributes<HTMLDivElement>) {
  const { className = "", ...rest } = props;
  return <div className={`mb-3 ${className}`} {...rest} />;
}

export function CardContent(props: React.HTMLAttributes<HTMLDivElement>) {
  const { className = "", ...rest } = props;
  return <div className={`${className}`} {...rest} />;
}
