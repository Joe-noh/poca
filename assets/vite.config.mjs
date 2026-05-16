import { svelte } from "@sveltejs/vite-plugin-svelte";
import tailwindcss from "@tailwindcss/vite";
import { readFileSync } from "fs";
import { resolve } from "path";
import { phoenixVitePlugin } from "phoenix_vite";
import { defineConfig } from "vite";

export default defineConfig({
  base: "/assets/",
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
      input: ["js/app.ts", "css/app.css"],
    },
    outDir: "../priv/static/assets",
    emptyOutDir: true,
  },
  resolve: {
    alias: {
      "~": resolve("./js"),
    },
  },
  plugins: [svelte(), tailwindcss(), phoenixVitePlugin({ pattern: /\.(ex|heex)$/ })],
});
