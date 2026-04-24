defmodule PocaWeb.PodcastLive do
  @moduledoc """
  Layout module for rendering podcast player live view and the viewport resize hook.
  """

  use PocaWeb, :live_view

  def render("with_player.html", assigns) do
    ~H"""
    <div>
      {@inner_content}
      {live_render(@socket, PocaWeb.PlayerLive, id: "player", session: %{}, sticky: true)}
      <div id="viewport-resize" phx-hook="ViewportResize" class="hidden" />
    </div>
    """
  end

  def on_mount(:default, _params, _session, socket) do
    socket =
      socket
      |> PocaWeb.Viewport.assign_device()
      |> attach_hook(:active_tab, :handle_params, &set_active_tab/3)

    {:cont, socket}
  end

  defp set_active_tab(_params, _url, socket) do
    active_tab =
      case {socket.view, socket.assigns.live_action} do
        {PocaWeb.PodcastLive.Listen, _} -> :home
        {PocaWeb.PodcastLive.Search, _} -> :search
        {_, _} -> nil
      end

    {:cont, assign(socket, active_tab: active_tab)}
  end
end
