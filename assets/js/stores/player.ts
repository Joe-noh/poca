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
    audioElement.pause();
    audioElement.src = episode.audioUrl;
    audioElement.currentTime = episode.playback?.currentTime || 0;
    audioElement.play();

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
