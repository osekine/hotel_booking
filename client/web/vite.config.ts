import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import { resolve } from "path";

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      "@modules": resolve(__dirname, "../modules"),
    },
  },
  server: {
    port: 3000,
    proxy: {
      "/graphql": {
        target: "http://api:4000",
        changeOrigin: true,
      },
    },
  },
});
