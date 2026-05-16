import Layout from "~/components/Layout/Layout.svelte";
import Listen from "~/pages/Listen.svelte";
import Library from "~/pages/Library.svelte";
import Queue from "~/pages/Queue.svelte";
import Search from "~/pages/Search.svelte";
import { createRouter } from "sv-router";

export const { p, navigate, isActive, route } = createRouter({
  "/listen": Listen,
  "/library": Library,
  "/queue": Queue,
  "/search": Search,
  layout: Layout,
});
