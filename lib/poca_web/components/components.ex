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
    <div class="grid grid-cols-4 fixed bottom-0 left-0 right-0 bg-paper backdrop-blur-lg border-t border-hairline pt-2.5 pb-2 px-2">
      <.tabbar_entry :for={item <- @item} to={item.to} active={Map.get(item, :active)} label={item.label} />
    </div>
    """
  end

  defp tabbar_entry(assigns) do
    ~H"""
    <.link navigate={@to} class={["flex flex-col justify-center items-center pb-4 w-full"]}>
      <div class={["w-1 h-1 rounded-full mb-1 mx-auto", @active && "bg-ink"]} />
      <span class={["font-sans text-sm tracking-wide transition-colors", if(@active, do: "text-ink", else: "text-muted")]}>{@label}</span>
    </.link>
    """
  end

  @doc "Desktop sidebar component"
  attr :entries, :list

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

  defp sidebar_entry(assigns) do
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

  attr :form, Phoenix.HTML.Form, required: true

  def search_input(assigns) do
    ~H"""
    <.form for={@form} id="search-form" phx-submit="search" class="flex items-center border-b pl-2 border-hairline focus-within:border-ink" phx-hook=".SearchInput">
      <.icon name="magnifying-glass" class="text-muted w-4 h-4" />
      <input
        type="text"
        name="query"
        inputmode="search"
        value={Phoenix.HTML.Form.normalize_value("text", @form[:query][:value])}
        class="flex-1 text-ink font-sans font-normal p-2 focus:outline-none placeholder:text-muted"
      />
    </.form>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".SearchInput">
      export default {
        mounted() {
          const input = this.el.querySelector('input[name="query"]');

          if (input.value === '') {
            input.focus();
          }
        }
      };
    </script>
    """
  end
end
