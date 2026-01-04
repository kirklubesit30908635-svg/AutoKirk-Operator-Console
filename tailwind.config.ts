import type { Config } from "tailwindcss";

export default {
  content: ["./app/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        obsidian: {
          950: "#050608",
          900: "#0a0c10",
          850: "#0f1218",
          800: "#141a22"
        },
        imperial: {
          gold: "#d1b26f",
          gold2: "#e6cc8a",
          gold3: "#9e7c2f"
        }
      },
      boxShadow: {
        royal: "0 12px 40px rgba(0,0,0,0.55)",
        edge: "0 0 0 1px rgba(209,178,111,0.18)"
      },
      borderRadius: {
        xl2: "1.25rem"
      }
    }
  },
  plugins: []
} satisfies Config;
