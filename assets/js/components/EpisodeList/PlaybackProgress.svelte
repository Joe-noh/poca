<script lang="ts">
  type Props = {
    episode: Episode;
  };

  const { episode }: Props = $props();

  function formatDuration(duration: number): string {
    const pad_zero = (num: number) => num.toString().padStart(2, "0");

    const hours = Math.floor(duration / 3600);
    const minutes = Math.floor((duration % 3600) / 60);
    const seconds = duration % 60;

    if (hours > 0) {
      return `${hours}:${pad_zero(minutes)}:${pad_zero(seconds)}`;
    } else if (minutes > 0) {
      return `${minutes}:${pad_zero(seconds)}`;
    } else {
      return `0:${pad_zero(seconds)}`;
    }
  }
</script>

<span class="text-sm font-sans text-muted">{formatDuration(episode.duration)}</span>
<div class="relative w-full h-0.5 rounded-md bg-hairline mt-1">
  <div
    class="absolute top-0 left-0 h-0.5 rounded-md bg-muted"
    data-testid="progress"
    style={"width: " + (episode.playback?.progress ?? 0) + "%"}
  ></div>
</div>
