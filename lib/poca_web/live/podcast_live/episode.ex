defmodule PocaWeb.PodcastLive.Episode do
  use PocaWeb, :live_view
  use PocaWeb.Viewport

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app device={@device} active_tab={@active_tab} flash={@flash}>
      <%= if @device == :mobile do %>
        <p class="text-center text-lg text-ink font-sans font-normal">
          mobile
        </p>
      <% else %>
        <p class="text-center text-lg text-ink font-serif font-normal">
          desktop
        </p>
      <% end %>
      <p class="text-center text-sm text-ink/70 font-sans font-normal">
        hello from episode page.
      </p>
      <.link navigate={~p"/listen"} class="text-center text-sm text-ink/70 font-sans font-normal">
        back to listen page
      </.link>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
