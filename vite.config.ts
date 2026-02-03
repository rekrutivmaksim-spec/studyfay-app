import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  // КРИТИЧЕСКИ ВАЖНО для CI (GitHub Actions) + Capacitor
  base: "./",
  plugins: [react()],
});
