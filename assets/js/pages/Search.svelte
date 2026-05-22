<script lang="ts">
  import { searchParams } from "sv-router";
  import { MagnifyingGlassIcon } from "phosphor-svelte";
  import { post } from "~/lib/fetcher";
  import PodcastThumbnail from "~/components/PodcastThumbnail/PodcastThumbnail.svelte";

  let query = $state("");
  let isLoading = $state(false);
  let podcasts: Podcast[] = $state([]);

  async function handleSubmit(event: Event) {
    event.preventDefault();

    searchParams.set("q", query);
  }

  $effect(() => {
    const q = searchParams.get("q");

    podcasts = [];
    isLoading = true;

    if (q === null || q === "") {
      isLoading = false;
    } else {
      query = q as string;
      post<{ podcasts: Podcast[] }>("/api/search", { q })
        .then((body) => body.podcasts)
        .then((results) => (podcasts = results))
        .catch(() => (podcasts = []))
        .finally(() => (isLoading = false));
    }
  });
</script>

<div class="p-2 sm:p-3 sticky top-0 left-0 right-0 border-b border-hairline bg-paper">
  <form class="group flex flex-row items-center gap-2 bg-paper-hover px-2 rounded-md" onsubmit={handleSubmit}>
    <MagnifyingGlassIcon class="w-4 h-4 text-ink" />
    <input bind:value={query} type="search" inputmode="search" class="w-full py-2 outline-none text-sans text-base" />
  </form>
</div>
{#if isLoading}
  <span>Searching...</span>
{:else}
  <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6 2xl:grid-cols-8 gap-x-2 gap-y-4 p-2 sm:gap-6 sm:p-6">
    {#each podcasts as podcast}
      <PodcastThumbnail {podcast} />
    {/each}
  </div>
{/if}
