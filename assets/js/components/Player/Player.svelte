<script lang="ts">
  import { playerStore, savePlaybackProgress } from "~/stores/player";

  type AudioEvent = Event & { currentTarget: HTMLAudioElement };

  let lastPlaybackSavedAt = 0;

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

    if ("mediaSession" in navigator && navigator.mediaSession.setPositionState) {
      if (currentTarget.duration > 0) {
        navigator.mediaSession.setPositionState({
          duration: currentTarget.duration,
          playbackRate: currentTarget.playbackRate,
          position: currentTarget.currentTime,
        });
      }
    }
  }

  // this.handleEvent(
  //   "play_audio",
  //   ({ id, url, title, author, image, duration, current_time }) => {
  //     episodeId = id;
  //     episodeTitle.textContent = title;
  //     podcastTitle.textContent = author;

  //     if ("mediaSession" in navigator) {
  //       navigator.mediaSession.metadata = new MediaMetadata({
  //         title,
  //         artist: author,
  //         artwork: [{ src: image, sizes: "600x600", type: "image/jpeg" }],
  //       });

  //       if (duration > 0) {
  //         navigator.mediaSession.setPositionState({
  //           duration: 1.0 * duration,
  //           playbackRate: 1,
  //           position: 1.0 * current_time,
  //         });
  //       }
  //     }

  //     audio.src = url;
  //     audio.currentTime = current_time;
  //     audio.play();
  //   },
  // );
</script>

<div
  class={[
    "flex flex-col justify-end gap-2 absolute bottom-12 left-0 right-0 bg-paper border-t border-hairline px-2.5 py-2",
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
    onpause={handlePause}
    onended={handleEnded}
    ontimeupdate={handleTimeUpdate}
  ></audio>
</div>
