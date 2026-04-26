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
        <% end %>

        <:loading>
          <div class="flex items-center justify-center w-full p-8">
            <.icon name="spinner" class="motion-safe:animate-[spin_1s_ease-in-out_infinite] text-ink w-6 h-6" />
          </div>
        </:loading>
      </.async_result>
      <div
        :if={@live_action == :show}
        id="podcast-modal"
        class={[
          "sticky bottom-0 right-0 left-0 h-1/2 pb-12 bg-paper border-t border-hairline overflow-y-auto",
          "transition-all duration-200 animate-slide-in starting:translate-y-full"
        ]}
      >
        <.async_result :let={podcast} assign={@podcast}>
          <div :if={podcast} class="flex flex-col gap-2 bg-paper p-8 w-full">
            <div class="grid grid-cols-[1fr_30px] grid-rows-1 gap-2 w-full">
              <div class="flex flex-col gap-1 flex-1 overflow-hidden">
                <h2 class="text-xl font-bold w-full">{podcast.title}</h2>
                <p class="font-sans text-sm text-muted">{podcast.author}</p>
              </div>
              <%= if length(podcast.subscribers) == 0 do %>
                <button
                  class="flex items-center justify-center bg-paper border border-muted rounded-full p-2 w-8 h-8 cursor-pointer hover:bg-hairline"
                  phx-click="subscribe"
                  phx-value-id={podcast.id}
                >
                  <.icon name="plus" class="text-ink w-5 h-5" />
                </button>
              <% else %>
                <button class="flex items-center justify-center bg-ink rounded-full p-2 w-8 h-8 cursor-pointer hover:bg-muted" phx-click="unsubscribe" phx-value-id={podcast.id}>
                  <.icon name="check" class="text-paper w-5 h-5" />
                </button>
              <% end %>
            </div>
            <p class="whitespace-pre-wrap leading-relaxed overflow-hidden">{podcast.description}</p>
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
      |> assign(:form, to_form(%{"query" => query}))
      |> assign_async(:podcast, fn -> {:ok, %{podcast: nil}} end)
      |> assign_async(:result, fn ->
        case Podcasts.Itunes.search(query) do
          {:ok, result} -> {:ok, %{result: result}}
          {:error, _reason} -> {:ok, %{result: []}}
        end
      end)

    {:ok, socket}
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:form, to_form(%{"query" => ""}))
      |> assign_async(:podcast, fn -> {:ok, %{podcast: nil}} end)
      |> assign_async(:result, fn -> {:ok, %{result: []}} end)

    {:ok, socket}
  end

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    {:noreply, push_navigate(socket, to: "/search?query=#{query}")}
  end

  def handle_event("open_podcast", %{"url" => url}, socket) do
    {:ok, %{podcast: podcast}} = Podcasts.create_podcast(%{"feed_url" => url})
    query = socket.assigns.form[:query].value || ""

    {:noreply, push_patch(socket, to: "/search/#{podcast.id}?query=#{query}")}
  end

  def handle_event("subscribe", %{"id" => id}, socket) do
    case Podcasts.get_podcast(id) do
      nil -> {:noreply, socket}
      podcast -> do_handle_subscribe(podcast, socket)
    end
  end

  def handle_event("unsubscribe", %{"id" => id}, socket) do
    case Podcasts.get_podcast(id) do
      nil -> {:noreply, socket}
      podcast -> do_handle_unsubscribe(podcast, socket)
    end
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    current_user = socket.assigns.current_user

    socket =
      socket
      |> assign_async(:podcast, fn -> {:ok, %{podcast: Podcasts.get_podcast(id, user: current_user)}} end)
      |> assign_async(:podcast, fn ->
        case Podcasts.get_podcast(id, user: current_user) do
          nil ->
            {:ok, %{podcast: nil}}

          podcast ->
            if Podcasts.Podcast.stale?(podcast) do
              with {:ok, %{podcast: podcast}} <- Podcasts.refresh_podcast(podcast) do
                Podcasts.refresh_episodes(podcast)

                {:ok, %{podcast: podcast}}
              end
            else
              {:ok, %{podcast: podcast}}
            end
        end
      end)

    {:noreply, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  defp do_handle_subscribe(podcast, socket) do
    current_user = socket.assigns.current_user

    case Podcasts.subscribe(podcast, current_user) do
      {:ok, _} ->
        socket =
          assign_async(socket, :podcast, fn ->
            podcast = Podcasts.get_podcast(podcast.id, user: current_user)

            {:ok, %{podcast: podcast}}
          end)

        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  defp do_handle_unsubscribe(podcast, socket) do
    current_user = socket.assigns.current_user

    case Podcasts.unsubscribe(podcast, current_user) do
      {:ok, _} ->
        socket =
          assign_async(socket, :podcast, fn ->
            podcast = Podcasts.get_podcast(podcast.id, user: current_user)

            {:ok, %{podcast: podcast}}
          end)

        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end
end
