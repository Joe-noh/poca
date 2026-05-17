<script lang="ts">
  import { createQueries, createMutation } from "@tanstack/svelte-query";
  import { CheckIcon, PlusIcon } from "phosphor-svelte";
  import { route } from "~/router";
  import { get, post, del } from "~/lib/fetcher";
  import EpisodeList from "~/components/EpisodeList/EpisodeList.svelte";

  const { id } = route.params;

  const query = createQueries(() => ({
    queries: [
      {
        queryKey: ["podcast", id],
        queryFn: () => {
          return get<{ podcast: Podcast }>(`/api/podcasts/${id}`).then((body) => body.podcast);
        },
      },
      {
        queryKey: ["podcast", id, "episodes"],
        queryFn: () => {
          return get<{ episodes: Episode[] }>(`/api/podcasts/${id}/episodes`).then((body) => body.episodes);
        },
      },
    ],
  }));

  let podcast = $derived<Podcast | undefined>(query[0].data);
  let episodes = $derived<Episode[]>(query[1].data || []);

  function handleToggleSubscribe() {
    if (podcast) {
      subscribe.mutate(!podcast.subscribed);
    }
  }

  const subscribe = createMutation(() => ({
    mutationFn: (subscribe: boolean) => {
      const path = `/api/podcasts/${query[0].data?.id}/subscription`;

      if (subscribe) {
        return post(path, {});
      } else {
        return del(path);
      }
    },
    onMutate: async (subscribe: boolean, { client }) => {
      const key = ["podcast", id];
      await client.cancelQueries({ queryKey: key });

      const prevPodcast = client.getQueryData<Podcast>(key);

      if (prevPodcast) {
        client.setQueryData<Podcast>(key, { ...prevPodcast, subscribed: subscribe });
      }

      return { prevPodcast };
    },
    onSettled: (_data, _error, _variables, _result, { client }) => {
      client.invalidateQueries({ queryKey: ["podcast", id] });
    },
  }));
</script>

{#if query.some((q) => q.isLoading)}
  <span></span>
{:else if query.some((q) => q.isError)}
  <span>{query.find((q) => q.isError)?.error.message}</span>
{:else if query.every((q) => q.data)}
  <div class="flex flex-col">
    <div class="flex flex-row gap-4 px-2 pt-2 sm:px-4 sm:pt-4">
      {#if podcast}
        <img src={podcast.artworkUrl} alt={podcast.title} class="w-24 sm:w-36 aspect-square object-cover rounded-md" />
        <div class="flex flex-col items-start justify-between gap-1">
          <div class="flex flex-col gap-1">
            <p class="font-bold font-sans text-ink">{podcast.title}</p>
            <p class="text-sm font-sans text-muted">{podcast.author}</p>
          </div>
          <button
            type="button"
            class={[
              "flex flex-row items-center gap-1 px-3 py-2 rounded-md bg-ink text-sm text-paper cursor-pointer",
              "outline-none focus-visible:ring-2 focus-visible:ring-offset-1 focus-visible:ring-ink transition-colors",
            ]}
            onclick={handleToggleSubscribe}
          >
            {#if podcast.subscribed}
              <CheckIcon weight="bold" class="w-3.5 h-3.5" />
              Subscribed
            {:else}
              <PlusIcon weight="bold" class="w-3.5 h-3.5" />
              Subscribe
            {/if}
          </button>
        </div>
      {/if}
    </div>

    <EpisodeList {episodes} />
  </div>
{/if}
