import { readFileSync } from "fs";
import { defineConfig } from "vite";
import { phoenixVitePlugin } from "phoenix_vite";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  server: {
    port: 5173,
    strictPort: true,
    cors: { origin: "https://localhost:4000" },
    https: {
      key: readFileSync("../priv/cert/selfsigned_key.pem"),
      cert: readFileSync("../priv/cert/selfsigned.pem"),
    },
  },
  build: {
    manifest: true,
    rollupOptions: {
      input: ["js/app.js", "css/app.css"],
    },
    outDir: "../priv/static",
    emptyOutDir: true,
  },
  resolve: {
    alias: {
      "~": ".",
    },
  },
  plugins: [tailwindcss(), phoenixVitePlugin({ pattern: /\.(ex|heex)$/ })],
});
