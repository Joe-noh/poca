import { createRouter } from "sv-router";
import Layout from "~/components/Layout/Layout.svelte";
import Library from "~/pages/Library.svelte";
import Listen from "~/pages/Listen.svelte";
import Podcast from "~/pages/Podcast.svelte";
import Queue from "~/pages/Queue.svelte";
import Search from "~/pages/Search.svelte";

export const { p, navigate, isActive, route } = createRouter({
  "/listen": Listen,
  "/library": Library,
  "/queue": Queue,
  "/search": Search,
  "/podcasts/:id": Podcast,
  layout: Layout,
});
