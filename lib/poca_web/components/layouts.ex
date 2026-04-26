defmodule PocaWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use PocaWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash} device={@device} active_tab={@active_tab}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :device, :atom, required: true, doc: "the device type, either :mobile or :desktop"
  attr :active_tab, :atom, required: true, doc: "the active tab in the sidebar or tabbar"
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :entries, :list, default: [], doc: "the list of sidebar entries"

  slot :inner_block, required: true

  def app(%{device: nil} = assigns) do
    ~H"""
    <main class="w-screen h-screen" />
    """
  end

  def app(assigns) do
    ~H"""
    <main class="grid grid-rows-[1fr_58px] sm:grid-cols-[240px_1fr] sm:grid-rows-[1fr_88px] w-screen h-screen">
      <%= if @device == :desktop do %>
        <.sidebar entries={@entries}>
          <:item label="HOME" to={~p"/listen"} active={@active_tab == :home} />
          <:item label="LIBRARY" to={~p"/library"} active={@active_tab == :library} />
          <:item label="QUEUE" to={~p"/queue"} active={@active_tab == :queue} />
          <:item label="SEARCH" to={~p"/search"} active={@active_tab == :search} />
        </.sidebar>
      <% end %>
      <div class="overflow-y-auto">
        {render_slot(@inner_block)}
      </div>
      <%= if @device == :mobile do %>
        <.tabbar>
          <:item label="HOME" to={~p"/listen"} active={@active_tab == :home} />
          <:item label="LIBRARY" to={~p"/library"} active={@active_tab == :library} />
          <:item label="QUEUE" to={~p"/queue"} active={@active_tab == :queue} />
          <:item label="SEARCH" to={~p"/search"} active={@active_tab == :search} />
        </.tabbar>
      <% end %>
    </main>
    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="arrow-clockwise" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="arrow-clockwise" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end
end
