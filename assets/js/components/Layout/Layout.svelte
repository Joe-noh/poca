<script lang="ts">
  import type { Snippet } from "svelte";
  import BottomBar from "~/components/BottomBar/BottomBar.svelte";
  import Player from "~/components/Player/Player.svelte";

  type Props = {
    children: Snippet;
  };

  let { children }: Props = $props();
</script>

<main class="max-w-4xl mx-auto">
  <div class="flex flex-col h-screen">
    <article class="flex-1 overflow-y-scroll">
      {@render children()}
    </article>
    <div class="sticky bottom-0">
      <Player />
      <BottomBar />
    </div>
  </div>
</main>
