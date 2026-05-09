<script lang="ts">
  import { formatDuration } from "~/lib/formatter";

  type Props = {
    episode: Episode;
  };

  const { episode }: Props = $props();

</script>

<span class="text-sm font-sans text-muted">{formatDuration(episode.duration)}</span>
<div class="relative w-full h-0.5 rounded-md bg-hairline mt-1">
  <div
    class="absolute top-0 left-0 h-0.5 rounded-md bg-muted"
    data-testid="progress"
    style={"width: " + (episode.playback?.progress ?? 0) + "%"}
  ></div>
</div>
