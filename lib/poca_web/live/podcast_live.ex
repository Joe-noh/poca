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
    {:cont, PocaWeb.Viewport.assign_device(socket)}
  end
end
