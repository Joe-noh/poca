<script lang="ts" module>
  export { default as layout } from "~/components/Layout/Layout.svelte";
</script>

<script lang="ts">
  import { CheckIcon, PlusIcon } from "phosphor-svelte";
  import EpisodeList from "~/components/EpisodeList/EpisodeList.svelte";

  type Props = {
    podcast: Podcast;
    episodes: Episode[];
  };

  const { podcast, episodes }: Props = $props();
  let subscribed = $state(podcast.subscribed);

  function handleToggleSubscribe() {
    if (subscribed) {
      fetch(`/podcasts/${podcast.id}/subscription`, {
        method: "DELETE",
        headers: { "Content-Type": "application/json" },
      });
      subscribed = false;
    } else {
      fetch(`/podcasts/${podcast.id}/subscription`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
      });
      subscribed = true;
    }
  }
</script>

<div class="flex flex-col">
  <div class="flex flex-row gap-4 px-2 pt-2 sm:px-4 sm:pt-4">
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
        {#if subscribed}
          <CheckIcon weight="bold" class="w-3.5 h-3.5" />
          Subscribed
        {:else}
          <PlusIcon weight="bold" class="w-3.5 h-3.5" />
          Subscribe
        {/if}
      </button>
    </div>
  </div>

  <EpisodeList {episodes} />
</div>
