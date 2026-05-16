<script lang="ts">
  import { createQuery } from "@tanstack/svelte-query";
  import { SpinnerIcon } from "phosphor-svelte";
  import EpisodeList from "~/components/EpisodeList/EpisodeList.svelte";
  import { get } from "~/lib/fetcher";

  const query = createQuery(() => ({
    queryKey: ["episodes"],
    queryFn: () => {
      return get<{ episodes: Episode[] }>("/api/episodes").then((body) => body.episodes);
    },
  }));
</script>

{#if query.isLoading}
  <div class="flex items-center justify-center py-8">
    <SpinnerIcon size={24} class="animate-spin" />
  </div>
{:else if query.isError}
  <span>Error: {query.error.message}</span>
{:else}
  <EpisodeList episodes={query.data || []} />
{/if}
