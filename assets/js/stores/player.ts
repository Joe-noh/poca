import { writable, get } from "svelte/store";

type PlayerState = {
  episode: Episode | null;
};

export const playerStore = writable<PlayerState>({
  episode: null,
});

export function clearCurrentEpisode() {
  playerStore.update((state) => ({ ...state, episode: null }));
}

export function playEpisode(episode: Episode) {
  let audioElement = getAudioElement();

  if (audioElement) {
    const { audioUrl, playback } = episode;

    audioElement.pause();
    audioElement.src = audioUrl;

    if (playback) {
      if (playback.currentTime > playback.duration * 0.95) {
        audioElement.currentTime = 0;
      } else {
        audioElement.currentTime = playback.currentTime || 0;
      }
    }

    audioElement.addEventListener("canplay", () => audioElement.play(), { once: true });

    if ("mediaSession" in navigator) {
      navigator.mediaSession.metadata = new MediaMetadata({
        title: episode.title,
        artist: episode.podcast?.author || "",
        album: episode.podcast?.title || "",
        artwork: [
          {
            src: episode.podcast?.artworkUrl || "",
            sizes: "600x600",
          },
        ],
      });
    }

    playerStore.update((state) => ({ ...state, episode }));
  }
}

export function savePlaybackProgress() {
  const audioElement = getAudioElement();
  const { episode } = get(playerStore);

  if (audioElement && episode) {
    const currentTime = audioElement.currentTime;
    const duration = audioElement.duration;
    const progress = (currentTime / duration) * 100;

    fetch(`/episodes/${episode.id}/playback`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        currentTime,
        duration,
        progress,
      }),
    });
  }

  return Date.now();
}

function getAudioElement(): HTMLAudioElement | null {
  return document.querySelector("audio#player");
}
