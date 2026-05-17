<script lang="ts">
  import type { Snippet } from "svelte";
  import BottomBar from "~/components/BottomBar/BottomBar.svelte";
  import SideBar from "~/components/SideBar/SideBar.svelte";
  import Player from "~/components/Player/Player.svelte";

  type Props = {
    children: Snippet;
  };

  let { children }: Props = $props();
</script>

<main class="h-screen">
  <div class="flex flex-col sm:flex-row h-screen">
    <SideBar />
    <article class="flex-1 overflow-y-scroll">
      {@render children()}
      <Player />
    </article>
    <BottomBar />
  </div>
</main>
