defmodule PocaWeb.PodcastLive.Listen do
  use PocaWeb, :live_view
  use PocaWeb.Viewport

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <%= if @device == :mobile do %>
        <p class="text-center text-lg text-ink font-sans font-normal">
          mobile
        </p>
      <% else %>
        <p class="text-center text-lg text-ink font-serif font-normal">
          desktop
        </p>
      <% end %>

      <div id="viewport-resize" phx-hook="ViewportResize" class="hidden" />
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, PocaWeb.Viewport.assign_device(socket)}
  end
end
