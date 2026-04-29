defmodule PocaWeb.PodcastLive.Listen do
  use PocaWeb, :live_view
  use PocaWeb.Viewport

  alias Poca.Podcasts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app device={@device} active_tab={@active_tab} flash={@flash}>
      <.async_result :let={episodes} assign={@episodes}>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 p-4">
          <%= for episode <- episodes do %>
            <div id={"episode-#{episode.id}"} class="episode-card flex flex-col cursor-pointer" phx-click="play_episode" phx-value-id={episode.id}>
              <p class="font-bold font-sans text-ink mb-1 truncate">{episode.title}</p>
              <p class="text-sm font-sans text-muted mb-1 truncate">{episode.podcast.title}</p>
              <p class="text-sm font-sans text-muted">{format_duration(episode.duration)}</p>
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
    socket = push_event(socket, "play_audio", %{url: episode.audio_url, title: episode.title, author: episode.podcast.title})

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

  defp pad_zero(value) when value < 10, do: "0#{value}"
  defp pad_zero(value), do: "#{value}"
end
