defmodule PocaWeb.PodcastLive.Listen do
  use PocaWeb, :live_view
  use PocaWeb.Viewport

  alias Poca.Podcasts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app device={@device} active_tab={@active_tab} flash={@flash}>
      <.async_result :let={episodes} assign={@episodes}>
        <div class="grid grid-cols-1 px-4 py-2">
          <%= for episode <- episodes do %>
            <.episode_entry episode={episode} />
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
      |> attach_hook(:play_episode, :handle_event, &PocaWeb.PodcastLive.hooked_event/3)

    {:ok, socket}
  end
end
