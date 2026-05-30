<script lang="ts">
  import { createQuery } from "@tanstack/svelte-query";
  import EpisodeList from "~/components/EpisodeList/EpisodeList.svelte";
  import { get } from "~/lib/fetcher";

  const query = createQuery(() => ({
    queryKey: ["episodes"],
    queryFn: () => {
      return get<{ episodes: Episode[] }>("/api/episodes").then((body) => body.episodes);
    },
  }));
</script>

<div class="min-h-screen">
  {#if query.isLoading}
    <span></span>
  {:else if query.isError}
    <span>{query.error.message}</span>
  {:else if query.data}
    <div class="min-h-screen">
      <EpisodeList episodes={query.data} />
    </div>
  {/if}
</div>
