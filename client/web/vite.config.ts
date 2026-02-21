import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import { resolve } from "path";

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      // import from "@modules/..." → client/modules/...
      "@modules": resolve(__dirname, "../modules"),
    },
  },
  server: {
    port: 3000,
    proxy: {
      // Dev only: proxy GraphQL requests to the API container
      // so the browser doesn't hit CORS issues.
      "/graphql": {
        target: "http://api:4000",
        changeOrigin: true,
      },
    },
  },
});
