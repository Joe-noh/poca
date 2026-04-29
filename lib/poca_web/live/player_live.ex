defmodule PocaWeb.PlayerLive do
  @moduledoc false
  use PocaWeb, :live_view

  def render(assigns) do
    ~H"""
    <div
      id="global-player"
      class={[
        "flex flex-col justify-start gap-2 absolute bottom-12 left-0 right-0 bg-paper border-t border-hairline px-2.5 py-2 z-50",
        "sm:bottom-0 sm:left-0 sm:right-0 sm:h-[110px] sm:ml-60 sm:shadow-none sm:border-t sm:border-l-0 sm:border-r-0 sm:border-b-0"
      ]}
      phx-hook=".GlobalPlayer"
    >
      <div class="flex flex-col justify-start gap-1 font-sans">
        <span id="episode-title" class="text-ink text-base truncate"> </span>
        <span id="podcast-title" class="text-muted text-sm truncate"> </span>
      </div>
      <audio id="audio-player" controls class="w-full" />
    </div>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".GlobalPlayer">
      export default {
        mounted() {
          const audio = document.getElementById('audio-player');
          const episodeTitle = document.getElementById('episode-title');
          const podcastTitle = document.getElementById('podcast-title');

          this.handleEvent('play_audio', ({ url, title, author }) => {
            episodeTitle.textContent = title;
            podcastTitle.textContent = author;

            audio.src = url;
            audio.play();
          });
        }
      };
    </script>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end
end
