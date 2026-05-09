<script lang="ts">
  import { formatDateTime } from "~/lib/formatter";
  import { playEpisode } from "~/stores/player";
  import PlaybackProgress from "./PlaybackProgress.svelte";

  type Props = {
    episode: Episode;
  };

  const { episode }: Props = $props();

  const publishedAt = $derived(formatDateTime(episode.publishedAt));

  function handleClick(event: Event) {
    event.preventDefault();

    playEpisode(episode);
  }
</script>

<button
  type="button"
  class="flex flex-row text-left items-start gap-4 p-1 w-full rounded-sm cursor-pointer outline-none focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:ring-ink transition-colors"
  onclick={handleClick}
>
  <img src={episode.podcast.artworkUrl} alt={episode.title} class="w-12 h-12 aspect-square bg-hairline rounded-md" />
  <div class="flex flex-col justify-between gap-1 w-full min-h-12 h-full">
    <span class="text-base font-sans text-ink">{episode.title}</span>
    <div class="flex flex-row justify-between items-end">
      <span class="text-sm text-muted">{publishedAt}</span>
      <div class="flex flex-col">
        <PlaybackProgress {episode} />
      </div>
    </div>
  </div>
</button>
