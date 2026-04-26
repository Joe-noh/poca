defmodule PocaWeb.PodcastLive.Listen do
  use PocaWeb, :live_view
  use PocaWeb.Viewport

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app device={@device} active_tab={@active_tab} flash={@flash}>
      <div />
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
