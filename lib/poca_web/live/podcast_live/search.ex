defmodule PocaWeb.PodcastLive.Search do
  use PocaWeb, :live_view
  use PocaWeb.Viewport

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app device={@device} active_tab={@active_tab} flash={@flash}>
      <div class="px-2 sticky top-0 left-0 right-0 bg-paper backdrop-blur-sm">
        <.search_input form={@form} />
      </div>
      <%= if @loading do %>
        <div class="flex items-center justify-center w-full p-8">
          <.icon name="spinner" class="motion-safe:animate-[spin_1s_ease-in-out_infinite] text-ink w-6 h-6" />
        </div>
      <% else %>
        <%= if @result do %>
          <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6 gap-8 p-8">
            <%= for entry <- @result do %>
              <div class="flex flex-col">
                <img src={entry.artwork_url_600} alt={entry.collection_name} class="w-full aspect-square object-cover mb-2 rounded-md" />
                <p class="font-bold font-sans text-ink mb-1 truncate">{entry.collection_name}</p>
                <p class="text-sm font-sans text-muted truncate">{entry.artist_name}</p>
              </div>
            <% end %>
          </div>
        <% else %>
          <p>No results</p>
        <% end %>
      <% end %>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"query" => query}, _session, socket) do
    send(self(), {:do_search, query})

    socket =
      socket
      |> assign(:loading, true)
      |> assign(:result, [])
      |> assign(:form, to_form(%{"query" => query}))

    {:ok, socket}
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:loading, false)
      |> assign(:result, [])
      |> assign(:form, to_form(%{"query" => ""}))

    {:ok, socket}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    {:noreply, push_navigate(socket, to: "/search?query=#{query}")}
  end

  @impl true
  def handle_info({:do_search, query}, socket) do
    case Poca.Podcasts.Itunes.search(query) do
      {:ok, result} ->
        socket =
          socket
          |> assign(:loading, false)
          |> assign(:result, result)

        {:noreply, socket}

      {:error, _reason} ->
        socket =
          socket
          |> assign(:loading, false)
          |> assign(:result, [])

        {:noreply, socket}
    end
  end
end
