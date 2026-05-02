defmodule PocaWeb.Components do
  @moduledoc """
  Provides domain UI components.
  """
  use Phoenix.Component
  use Gettext, backend: PocaWeb.Gettext

  import PocaWeb.CoreComponents

  alias Poca.Podcasts

  @doc "Mobile tab bar component"
  slot :item, required: true do
    attr :label, :string
    attr :to, :string
    attr :active, :boolean
  end

  def tabbar(assigns) do
    ~H"""
    <div class="grid grid-cols-4 h-12 fixed bottom-0 left-0 right-0 bg-paper border-t border-hairline px-2">
      <.tabbar_entry :for={item <- @item} to={item.to} active={Map.get(item, :active)} label={item.label} />
    </div>
    """
  end

  defp tabbar_entry(assigns) do
    ~H"""
    <.link navigate={@to} class={["flex flex-col justify-center items-center pb-0 w-full"]}>
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

  attr :episode, Podcasts.Episode, required: true

  def episode_entry(assigns) do
    ~H"""
    <div
      id={"episode-#{@episode.id}"}
      class="flex flex-row items-start gap-4 py-2.5 w-full cursor-pointer border-b border-hairline"
      phx-click="play_episode"
      phx-value-id={@episode.id}
    >
      <img src={@episode.podcast.artwork_url} alt={@episode.title} class="w-12 h-12 bg-hairline rounded-md" />
      <div class="flex flex-col justify-between w-full h-full gap-0.5">
        <span class="text-base font-sans text-ink">{@episode.title}</span>
        <div class="flex flex-row justify-between items-end">
          <.episode_published_at episode={@episode} />
          <div class="flex flex-col">
            <.playback_progress episode={@episode} />
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :episode, Podcasts.Episode, required: true

  def episode_published_at(assigns) do
    ~H"""
    <span id={"episode-#{@episode.id}-published-at"} class="text-sm font-sans text-muted" phx-hook=".EpisodePublishedAt" data-value={@episode.published_at} />
    <script :type={Phoenix.LiveView.ColocatedHook} name=".EpisodePublishedAt">
      export default {
        mounted() {
          this.displayPublishedAt(this.el);
        },

        updated() {
          this.displayPublishedAt(this.el);
        },

        displayPublishedAt(span) {
          const publishedAt = new Date(span.dataset.value);
          const options = { year: 'numeric', month: 'short', day: 'numeric', hour: 'numeric', minute: '2-digit' };

          span.textContent = new Intl.DateTimeFormat(undefined, options).format(publishedAt);
        }
      };
    </script>
    """
  end

  attr :episode, Podcasts.Episode, required: true

  def playback_progress(assigns) do
    ~H"""
    <span class="text-sm font-sans text-muted">{Podcasts.Episode.format_duration(@episode)}</span>
    <div class="relative w-full h-0.5 rounded-md bg-hairline mt-1">
      <div class="absolute top-0 left-0 h-0.5 rounded-md bg-muted" style={"width: '#{Podcasts.Playback.progress(@episode.playback)}%'"}></div>
    </div>
    """
  end
end
