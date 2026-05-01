defmodule PocaWeb.PodcastLive.Listen do
  use PocaWeb, :live_view
  use PocaWeb.Viewport

  alias Poca.Podcasts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app device={@device} active_tab={@active_tab} flash={@flash}>
      <.async_result :let={episodes} assign={@episodes}>
        <div class="grid grid-cols-1 px-4">
          <%= for episode <- episodes do %>
            <div
              id={"episode-#{episode.id}"}
              class="flex flex-row items-start gap-4 py-2 w-full cursor-pointer border-b border-hairline"
              phx-click="play_episode"
              phx-value-id={episode.id}
            >
              <img src={episode.podcast.artwork_url} alt={episode.title} class="w-12 h-12 bg-hairline rounded-md" />
              <div class="flex flex-col justify-between w-full h-full gap-0.5">
                <span class="text-base font-sans text-ink">{episode.title}</span>
                <div class="flex flex-row justify-between items-end">
                  <.episode_published_at episode={episode} />
                  <div class="flex flex-col">
                    <span class="text-sm font-sans text-muted">{format_duration(episode.duration)}</span>
                    <div class="relative w-full h-0.5 rounded-md bg-hairline mt-1">
                      <div class="absolute top-0 left-0 h-0.5 rounded-md bg-muted" style={"width: #{playback_progress(episode)}"}></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          <% end %>
        </div>
      </.async_result>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    socket =
      socket
      |> assign_async(:episodes, fn -> Podcasts.subscribed_episodes(current_user) end)

    {:ok, socket}
  end

  @impl true
  def handle_event("play_episode", %{"id" => episode_id}, socket) do
    episode = Podcasts.get_episode(episode_id)
    playback = Podcasts.get_playback(episode, socket.assigns.current_user)

    socket =
      socket
      |> assign(:current_episode, episode)
      |> push_event("play_audio", %{
        id: episode.id,
        url: episode.audio_url,
        title: episode.title,
        author: episode.podcast.title,
        image: episode.podcast.artwork_url,
        duration: episode.duration,
        current_time: (playback && playback.current_time) || 0
      })

    {:noreply, socket}
  end

  defp format_duration(duration) when is_integer(duration) do
    hours = div(duration, 3600)
    minutes = div(rem(duration, 3600), 60)
    seconds = rem(duration, 60)

    cond do
      hours > 0 -> "#{hours}:#{pad_zero(minutes)}:#{pad_zero(seconds)}"
      minutes > 0 -> "#{minutes}:#{pad_zero(seconds)}"
      true -> "0:#{pad_zero(seconds)}"
    end
  end

  defp format_duration(_), do: "0:00"

  defp pad_zero(value) when value < 10, do: "0#{value}"
  defp pad_zero(value), do: "#{value}"

  defp playback_progress(%{playback: %{current_time: current_time, duration: duration}}) when duration > 0 do
    "#{round(current_time / duration * 100)}%"
  end

  defp playback_progress(_), do: "0%"
end
