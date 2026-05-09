<script lang="ts">
  import { PlayIcon, PauseIcon } from "phosphor-svelte";
  import { formatDuration } from "~/lib/formatter";
  import { playerStore, togglePlay } from "~/stores/player";
</script>

{#if $playerStore.episode}
  <div
    class={[
      "flex flex-col justify-end gap-3 absolute bottom-12 left-0 right-0 bg-paper border-t border-hairline p-2.5 z-20",
      "sm:bottom-0 sm:left-0 sm:right-0 sm:ml-54 sm:shadow-none sm:border-t sm:border-l-0 sm:border-r-0 sm:border-b-0",
    ]}
  >
    <div class="flex flex-row items-center gap-4">
      <button
        onclick={togglePlay}
        class={[
          "text-paper bg-ink rounded-full p-2.5 cursor-pointer transition-colors disabled:cursor-not-allowed disabled:bg-hairline disabled:text-muted",
          "outline-none focus-visible:ring-2 focus-visible:ring-offset-2 focus-visible:ring-ink",
        ]}
      >
        {#if $playerStore.playing}
          <PauseIcon weight="fill" size={16} />
        {:else}
          <PlayIcon weight="fill" size={16} />
        {/if}
      </button>
      <input
        type="range"
        value={$playerStore.audio?.currentTime}
        max={$playerStore.audio?.duration}
        class={[
          "w-full h-3 flex-1 appearance-none bg-transparent outline-none cursor-pointer",
          "[&::-webkit-slider-runnable-track]:rounded-full [&::-webkit-slider-runnable-track]:bg-hairline [&::-webkit-slider-runnable-track]:h-1",
          "[&::-webkit-slider-thumb]:appearance-none [&::-webkit-slider-thumb]:w-3 [&::-webkit-slider-thumb]:h-3 [&::-webkit-slider-thumb]:-mt-1 [&::-webkit-slider-thumb]:rounded-full [&::-webkit-slider-thumb]:bg-ink",
        ]}
      />
      <p class="text-base font-sans text-ink">
        {formatDuration(Math.round($playerStore.currentTime))} / {formatDuration(Math.round($playerStore.duration))}
      </p>
    </div>
    <div class="flex flex-col justify-start gap-1 font-sans">
      <span id="episode-title" class="text-ink text-base leading-4 truncate">{$playerStore.episode?.title}</span>
      <span id="podcast-title" class="text-muted text-sm leading-4 truncate">{$playerStore.episode?.podcast?.author}</span>
    </div>
  </div>
{/if}
