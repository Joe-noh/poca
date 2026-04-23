defmodule PocaWeb.Components do
  @moduledoc """
  Provides domain UI components.
  """
  use Phoenix.Component
  use Gettext, backend: PocaWeb.Gettext

  import PocaWeb.CoreComponents

  @doc "Mobile tab bar component"
  slot :item, required: true do
    attr :label, :string
    attr :to, :string
    attr :active, :boolean
  end

  def tabbar(assigns) do
    ~H"""
    <div class="grid grid-cols-4 absolute bottom-0 left-0 right-0 bg-paper backdrop-blur-lg border-t border-hairline pt-2.5 pb-2 px-2">
      <.link :for={item <- @item} navigate={item.to} class="flex flex-col justify-center items-center pb-4 w-full">
        <div class={[Map.get(item, :active) && "bg-ink", "w-1 h-1 rounded-full mb-1 mx-auto"]} />
        <.text font="sans" size="sm" color={if Map.get(item, :active), do: "ink", else: "muted"}>{item.label}</.text>
      </.link>
    </div>
    """
  end

  @doc "Desktop sidebar component"
  slot :item, required: true do
    attr :label, :string
    attr :to, :string
    attr :active, :boolean
  end

  def sidebar(assigns) do
    ~H"""
    <aside class="flex flex-col gap-7 row-span-2 border-r border-hairline p-7">
      <.link navigate="/" class="w-8 h-8 mb-6">
        <img src="/images/logo.svg" alt="POCA" class="w-full h-full" />
      </.link>
      <div class="flex flex-col gap-2.5">
        <.sidebar_entry :for={item <- @item} to={item.to} active={Map.get(item, :active)} label={item.label} />
      </div>
    </aside>
    """
  end

  def sidebar_entry(assigns) do
    ~H"""
    <.link
      navigate={@to}
      class={["group flex flex-row items-center justify-start gap-4 px-3 py-2.5 rounded-md hover:bg-hairline transition-colors", @active && "bg-ink hover:text-muted"]}
    >
      <div :if={@active} class="bg-paper w-1 h-1 rounded-full group-hover:bg-muted" />
      <div :if={!@active} class="bg-muted w-1 h-1 rounded-full" />
      <span class={["font-sans text-sm text-ink tracking-wide transition-colors", @active && "text-paper group-hover:text-ink"]}>{@label}</span>
    </.link>
    """
  end
end
