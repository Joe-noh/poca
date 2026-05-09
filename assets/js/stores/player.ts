import { writable, get } from "svelte/store";

type PlayerState = {
  audio: HTMLAudioElement;
  playing: boolean;
  currentTime: number;
  duration: number;
  episode: Episode | null;
  lastPlaybackSavedAt: number;
};

const audio = new Audio();

audio.addEventListener("play", (event) => {
  const target = event.currentTarget as HTMLAudioElement;

  setPlaying(true);

  if (target.duration > 0) {
    playerStore.update((state) => ({
      ...state,
      currentTime: target.currentTime,
      duration: target.duration,
    }));

    if ("mediaSession" in navigator) {
      navigator.mediaSession.playbackState = "playing";
      navigator.mediaSession.setPositionState({
        duration: target.duration,
        playbackRate: 1,
        position: target.currentTime,
      });
    }
  }
});

audio.addEventListener("pause", () => {
  savePlaybackProgress(audio);
  setPlaying(false);

  if ("mediaSession" in navigator) {
    navigator.mediaSession.playbackState = "paused";
  }
});

audio.addEventListener("ended", () => {
  savePlaybackProgress(audio);
  setPlaying(false);

  if ("mediaSession" in navigator) {
    navigator.mediaSession.playbackState = "none";
  }
});

audio.addEventListener("timeupdate", (event) => {
  const target = event.currentTarget as HTMLAudioElement;
  const { lastPlaybackSavedAt } = get(playerStore);

  if (Date.now() - lastPlaybackSavedAt > 20 * 1000) {
    savePlaybackProgress(audio);
  }

  playerStore.update((state) => ({ ...state, currentTime: target.currentTime }));

  if ("mediaSession" in navigator) {
    if (target.duration > 0) {
      navigator.mediaSession.setPositionState({
        duration: target.duration,
        playbackRate: target.playbackRate,
        position: target.currentTime,
      });
    }
  }
});

audio.addEventListener("durationchange", (event) => {
  const target = event.currentTarget as HTMLAudioElement;

  playerStore.update((state) => ({ ...state, duration: target.duration }));
});

export const playerStore = writable<PlayerState>({
  audio,
  playing: false,
  currentTime: 0,
  duration: 0,
  episode: null,
  lastPlaybackSavedAt: 0,
});

export function clearCurrentEpisode() {
  playerStore.update((state) => ({ ...state, episode: null }));
}

export function playEpisode(episode: Episode) {
  const { audio } = get(playerStore);

  if (audio) {
    const { audioUrl, playback } = episode;

    audio.pause();
    audio.src = audioUrl;

    if (playback) {
      if (playback.currentTime > playback.duration * 0.95) {
        audio.currentTime = 0;
      } else {
        audio.currentTime = playback.currentTime || 0;
      }
    }

    audio.addEventListener("canplay", () => audio.play(), { once: true });

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

    playerStore.update((state) => ({ ...state, episode, playing: true }));
  }
}

export function togglePlay() {
  const { audio } = get(playerStore);

  if (audio) {
    setPlaying(!audio.paused);

    audio.paused ? audio.play() : audio.pause();
  }
}

function setPlaying(playing: boolean) {
  playerStore.update((state) => ({ ...state, playing }));
}

function savePlaybackProgress({ currentTime, duration }: HTMLAudioElement) {
  const { episode } = get(playerStore);

  if (episode) {
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

  playerStore.update((state) => ({ ...state, lastPlaybackSavedAt: Date.now() }));
}
