import Listen from "./pages/Listen.svelte";
import Search from "./pages/Search.svelte";
import { createRouter } from "sv-router";

export const { p, navigate, isActive, route } = createRouter({
  "/listen": Listen,
  "/search": Search,
});
