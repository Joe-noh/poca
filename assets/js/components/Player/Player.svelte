<script lang="ts">
  import { playerStore, savePlaybackProgress } from "~/stores/player";

  type AudioEvent = Event & { currentTarget: HTMLAudioElement };

  let lastPlaybackSavedAt = 0;

  function handlePlay({ currentTarget }: AudioEvent) {
    if ("mediaSession" in navigator) {
      if (currentTarget.duration > 0) {
        navigator.mediaSession.playbackState = "playing";
        navigator.mediaSession.setPositionState({
          duration: currentTarget.duration,
          playbackRate: 1,
          position: currentTarget.currentTime,
        });
      }
    }
  }

  function handlePause() {
    lastPlaybackSavedAt = savePlaybackProgress();

    if ("mediaSession" in navigator) {
      navigator.mediaSession.playbackState = "paused";
    }
  }

  function handleEnded(_event: AudioEvent) {
    lastPlaybackSavedAt = savePlaybackProgress();

    if ("mediaSession" in navigator) {
      navigator.mediaSession.playbackState = "none";
    }
  }

  function handleTimeUpdate({ currentTarget }: AudioEvent) {
    if (Date.now() - lastPlaybackSavedAt > 20 * 1000) {
      lastPlaybackSavedAt = savePlaybackProgress();
    }

    if ("mediaSession" in navigator) {
      if (currentTarget.duration > 0) {
        navigator.mediaSession.setPositionState({
          duration: currentTarget.duration,
          playbackRate: currentTarget.playbackRate,
          position: currentTarget.currentTime,
        });
      }
    }
  }
</script>

<div
  class={[
    "flex flex-col justify-end gap-2 absolute bottom-12 left-0 right-0 bg-paper border-t border-hairline px-2.5 py-2 z-20",
    "sm:bottom-0 sm:left-0 sm:right-0 sm:ml-60 sm:shadow-none sm:border-t sm:border-l-0 sm:border-r-0 sm:border-b-0",
  ]}
>
  <div class="flex flex-col justify-start gap-1 font-sans">
    <span id="episode-title" class="text-ink text-base truncate"
      >{$playerStore.episode?.title}</span
    >
    <span id="podcast-title" class="text-muted text-sm truncate"
      >{$playerStore.episode?.podcast?.author}</span
    >
  </div>
  <audio
    controls
    id="player"
    class="w-full h-12"
    onplay={handlePlay}
    onpause={handlePause}
    onended={handleEnded}
    ontimeupdate={handleTimeUpdate}
  ></audio>
</div>
