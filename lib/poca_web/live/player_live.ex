defmodule PocaWeb.PlayerLive do
  @moduledoc false
  use PocaWeb, :live_view

  alias Poca.{Podcasts, Accounts}

  def render(assigns) do
    ~H"""
    <div
      id="global-player"
      class={[
        "flex flex-col justify-end gap-2 absolute bottom-12 left-0 right-0 bg-paper border-t border-hairline px-2.5 py-2 z-50",
        "sm:bottom-0 sm:left-0 sm:right-0 sm:ml-60 sm:shadow-none sm:border-t sm:border-l-0 sm:border-r-0 sm:border-b-0"
      ]}
      phx-hook=".GlobalPlayer"
    >
      <div class="flex flex-col justify-start gap-1 font-sans">
        <span id="episode-title" class="text-ink text-base truncate">{get_in(assigns, [:current_episode, :title])}</span>
        <span id="podcast-title" class="text-muted text-sm truncate">{get_in(assigns, [:current_episode, :author])}</span>
      </div>
      <audio id="audio-player" controls class="w-full h-12" />
    </div>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".GlobalPlayer">
      let episodeId = null;
      let lastPlaybackSavedAt = 0;

      export default {
        mounted() {
          const audio = document.getElementById('audio-player');
          const episodeTitle = document.getElementById('episode-title');
          const podcastTitle = document.getElementById('podcast-title');

          audio.addEventListener('pause', () => {
            if ('mediaSession' in navigator) {
              navigator.mediaSession.playbackState = 'paused';
            }
          });

          audio.addEventListener('ended', ({ target }) => {
            this.savePlaybackProgress(episodeId, target.currentTime, target.duration);

            if ('mediaSession' in navigator) {
              navigator.mediaSession.playbackState = 'none';
            }
          });

          audio.addEventListener('timeupdate', ({ target }) => {
            this.savePlaybackProgress(episodeId, target.currentTime, target.duration);

            if ('mediaSession' in navigator && navigator.mediaSession.setPositionState) {
              if (target.duration > 0) {
                navigator.mediaSession.setPositionState({
                  duration: target.duration,
                  playbackRate: target.playbackRate,
                  position: target.currentTime,
                });
              }
            }
          });

          this.handleEvent('play_audio', ({ id, url, title, author, image, duration, current_time }) => {
            episodeId = id;
            episodeTitle.textContent = title;
            podcastTitle.textContent = author;

            if ('mediaSession' in navigator) {
              navigator.mediaSession.metadata = new MediaMetadata({
                title,
                artist: author,
                artwork: [{ src: image, sizes: '600x600', type: 'image/jpeg' }],
              });

              if (duration > 0) {
                navigator.mediaSession.setPositionState({
                  duration: 1.0 * duration,
                  playbackRate: 1,
                  position: 1.0 * current_time,
                });
              }
            }

            audio.src = url;
            audio.currentTime = current_time;
            audio.play();
          });
        },

        savePlaybackProgress(episodeId, currentTime, duration) {
          if (!episodeId) return;

          const now = Date.now();

          if (now - lastPlaybackSavedAt > 10000) {
            lastPlaybackSavedAt = now;

            this.pushEvent("save_playback_progress", {
              episode_id: episodeId,
              current_time: currentTime,
              duration: duration,
            });
          }
        },
      };
    </script>
    """
  end

  def mount(_params, %{"user_id" => user_id}, socket) do
    socket = socket |> assign(:current_user, Accounts.get_user(user_id))

    {:ok, socket, layout: false}
  end

  def handle_event("save_playback_progress", params, socket) do
    %{"episode_id" => episode_id, "current_time" => current_time, "duration" => duration} = params

    user = socket.assigns.current_user
    episode = Podcasts.get_episode(episode_id)

    Podcasts.save_playback_progress(user, episode, current_time, duration)

    {:noreply, socket}
  end
end
