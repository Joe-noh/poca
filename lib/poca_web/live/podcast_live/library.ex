defmodule PocaWeb.PodcastLive.Library do
  use PocaWeb, :live_view
  use PocaWeb.Viewport

  alias Poca.Podcasts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app device={@device} active_tab={@active_tab} flash={@flash}>
      <.async_result :let={podcasts} assign={@podcasts}>
        <div class="grid grid-cols-1 px-4">
          <%= for podcast <- podcasts do %>
            <div id={"podcast-#{podcast.id}"} class="flex flex-row items-start gap-4 py-2 w-full cursor-pointer border-b border-hairline">
              <img src={podcast.artwork_url} alt={podcast.title} class="w-12 h-12 bg-hairline rounded-md" />
              <div class="flex flex-col justify-between w-full h-full gap-0.5">
                <span class="text-base font-sans text-ink">{podcast.title}</span>
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
      |> assign_async(:podcasts, fn -> Podcasts.subscribed_podcasts(current_user) end)

    {:ok, socket}
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
