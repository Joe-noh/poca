<script lang="ts" module>
  export { default as layout } from "~/components/Layout/Layout.svelte";
</script>

<script lang="ts">
  import { router } from "@inertiajs/svelte";
  import { MagnifyingGlassIcon } from "phosphor-svelte";
  import PodcastThumbnail from "~/components/PodcastThumbnail/PodcastThumbnail.svelte";

  type Props = {
    podcasts: Podcast[];
  };

  const { podcasts }: Props = $props();
  let query = $state("");

  function handleSubmit(event: Event) {
    event.preventDefault();

    router.post("/search", { q: query });
  }
</script>

<div class="p-2 sm:p-3 sticky top-0 left-0 right-0 border-b border-hairline bg-paper">
  <form class="group flex flex-row items-center gap-2 bg-paper-hover px-2 rounded-md" onsubmit={handleSubmit}>
    <MagnifyingGlassIcon class="w-4 h-4 text-ink" />
    <input bind:value={query} type="search" inputmode="search" class="w-full py-2 outline-none text-sans text-base" />
  </form>
</div>
<div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6 2xl:grid-cols-8 gap-x-2 gap-y-4 p-2 sm:gap-6 sm:p-6">
  {#each podcasts as podcast}
    <PodcastThumbnail {podcast} />
  {/each}
</div>
