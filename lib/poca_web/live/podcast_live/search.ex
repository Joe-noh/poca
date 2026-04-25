defmodule PocaWeb.PodcastLive.Search do
  use PocaWeb, :live_view
  use PocaWeb.Viewport

  alias Poca.Podcasts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app device={@device} active_tab={@active_tab} flash={@flash}>
      <div class="px-2 sticky top-0 left-0 right-0 bg-paper backdrop-blur-sm">
        <.search_input form={@form} />
      </div>
      <.async_result :let={result} assign={@result}>
        <%= if length(result) > 0 do %>
          <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6 gap-8 p-8">
            <%= for entry <- result do %>
              <div id={"search-result-#{entry.collection_id}"} class="search-result flex flex-col cursor-pointer" phx-click="open_podcast" phx-value-url={entry.feed_url}>
                <img src={entry.artwork_url_600} alt={entry.collection_name} class="w-full aspect-square object-cover mb-2 rounded-md" />
                <p class="font-bold font-sans text-ink mb-1 truncate">{entry.collection_name}</p>
                <p class="text-sm font-sans text-muted truncate">{entry.artist_name}</p>
              </div>
            <% end %>
          </div>
        <% else %>
          <p>No results</p>
        <% end %>

        <:loading>
          <div class="flex items-center justify-center w-full p-8">
            <.icon name="spinner" class="motion-safe:animate-[spin_1s_ease-in-out_infinite] text-ink w-6 h-6" />
          </div>
        </:loading>
      </.async_result>
      <div
        :if={@selected}
        id="podcast-modal"
        class="sticky bottom-0 right-0 left-0 h-1/3 bg-paper backdrop-blur-md border-t border-hairline transition-all duration-200 animate-slide-in starting:translate-y-full"
      >
        <.async_result :let={podcast} assign={@podcast}>
          <div :if={podcast} class="bg-paper p-8 w-full max-w-md">
            <h2 class="text-xl font-bold mb-4">{podcast.title}</h2>
            <p class="mb-4">{podcast.author}</p>
            <p class="mb-4">{podcast.feed_url}</p>
          </div>
          <:loading>
            <div class="flex items-center justify-center w-full p-8">
              <.icon name="spinner" class="motion-safe:animate-[spin_1s_ease-in-out_infinite] text-ink w-6 h-6" />
            </div>
          </:loading>
        </.async_result>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"query" => query}, _session, socket) do
    socket =
      socket
      |> assign(:selected, nil)
      |> assign(:form, to_form(%{"query" => query}))
      |> assign_async(:podcast, fn -> {:ok, %{podcast: nil}} end)
      |> assign_async(:result, fn ->
        case Poca.Podcasts.Itunes.search(query) do
          {:ok, result} -> {:ok, %{result: result}}
          {:error, _reason} -> {:ok, %{result: []}}
        end
      end)

    {:ok, socket}
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:selected, nil)
      |> assign(:form, to_form(%{"query" => ""}))
      |> assign_async(:podcast, fn -> {:ok, %{podcast: nil}} end)
      |> assign_async(:result, fn -> {:ok, %{result: []}} end)

    {:ok, socket}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    {:noreply, push_navigate(socket, to: "/search?query=#{query}")}
  end

  @impl true
  def handle_event("open_podcast", %{"url" => url}, socket) do
    socket =
      socket
      |> assign(:selected, true)
      |> assign_async(:podcast, fn ->
        with {:ok, %{podcast: podcast}} <- Podcasts.create_podcast(%{feed_url: url}),
             {:ok, %{podcast: podcast}} <- Podcasts.refresh_podcast(podcast),
             {:ok, _feed} <- Podcasts.refresh_episodes(podcast) do
          {:ok, %{podcast: podcast}}
        else
          _error ->
            {:ok, %{podcast: nil}}
        end
      end)

    {:noreply, socket}
  end
end
