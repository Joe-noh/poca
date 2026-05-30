<script lang="ts">
  import { derived } from "svelte/store";
  import { PlayIcon, PauseIcon, ArrowCounterClockwiseIcon, ArrowClockwiseIcon } from "phosphor-svelte";
  import { formatDuration } from "~/lib/formatter";
  import { playerStore, togglePlay, seekTo } from "~/stores/player";

  const rate = derived(playerStore, ({ audio }) => {
    if (audio?.currentTime && audio?.duration) {
      return Math.round((1000 * audio.currentTime) / audio.duration) / 10;
    } else {
      return 0;
    }
  });

  function handleSeek(event: Event) {
    const input = event.target as HTMLInputElement;
    const newTime = Number(input.value);

    seekTo(newTime);
  }
</script>

{#if $playerStore.episode}
  <div class="sticky bottom-0 left-0 right-0">
    <div class="flex flex-col justify-end gap-3 bg-paper border-t border-hairline px-2.5 pt-2 pb-4 z-20">
      <div class="flex flex-row items-center gap-4">
        <input
          type="range"
          value={$playerStore.audio?.currentTime}
          max={$playerStore.audio?.duration}
          style={"--rate: " + $rate + "%"}
          class="w-full h-3 flex-1 appearance-none outline-none cursor-pointer"
          onchange={handleSeek}
        />
        <p class="text-base font-serif text-ink">
          {formatDuration(Math.round($playerStore.currentTime))} / {formatDuration(Math.round($playerStore.duration))}
        </p>
      </div>

      <div class="flex flex-col justify-start gap-1 font-serif">
        <span id="episode-title" class="text-ink text-base leading-4 truncate">{$playerStore.episode?.title}</span>
        <span id="podcast-title" class="text-muted text-sm leading-4 truncate">{$playerStore.episode?.podcast?.author}</span>
      </div>
      <div class="flex flex-row items-center justify-center gap-4">
        <button
          title="Rewind 15 seconds"
          onclick={() => seekTo($playerStore.currentTime - 15)}
          class={[
            "text-ink bg-paper border-ink border rounded-full p-2.5 transition-colors cursor-pointer",
            "outline-none focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:ring-ink",
          ]}
        >
          <ArrowCounterClockwiseIcon weight="fill" size={16} />
        </button>
        <button
          onclick={togglePlay}
          class={[
            "text-paper bg-ink border-ink border rounded-full p-3 cursor-pointer transition-colors disabled:cursor-not-allowed disabled:bg-hairline disabled:text-muted",
            "outline-none focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:ring-ink",
          ]}
        >
          {#if $playerStore.playing}
            <PauseIcon weight="fill" size={16} />
          {:else}
            <PlayIcon weight="fill" size={16} />
          {/if}
        </button>
        <button
          title="Forward 30 seconds"
          onclick={() => seekTo($playerStore.currentTime + 30)}
          class={[
            "text-ink bg-paper border-ink border rounded-full p-2.5 transition-colors cursor-pointer",
            "outline-none focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:ring-ink",
          ]}
        >
          <ArrowClockwiseIcon weight="fill" size={16} />
        </button>
      </div>
    </div>
  </div>
{/if}

<style>
  input[type="range"]::-webkit-slider-runnable-track {
    background: linear-gradient(90deg, var(--color-ink) var(--rate), var(--color-hairline) var(--rate));
    border-radius: calc(0.5 * var(--spacing));
    height: var(--spacing);
  }

  input[type="range"]::-webkit-slider-thumb {
    appearance: none;
    width: calc(3 * var(--spacing));
    height: calc(3 * var(--spacing));
    margin-top: calc(-1 * var(--spacing));
    border-radius: 50%;
    background: var(--color-ink);
  }
</style>
