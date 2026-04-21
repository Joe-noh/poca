defmodule PocaWeb.PodcastLive.Listen do
  use PocaWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      Listen
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    IO.inspect(user)

    {:ok, socket}
  end
end
