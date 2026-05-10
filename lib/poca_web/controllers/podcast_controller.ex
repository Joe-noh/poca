defmodule PocaWeb.PodcastController do
  use PocaWeb, :controller

  alias Poca.Podcasts

  def show(conn, %{"id" => id}) do
    case Podcasts.get_podcast(id, user: conn.assigns.current_user) do
      nil ->
        conn |> redirect(to: ~p"/")

      podcast ->
        conn
        |> assign_prop(:active_tab, "library")
        |> assign_prop(:podcast, PocaWeb.ResourceJSON.render(podcast))
        |> assign_prop(
          :episodes,
          inertia_once(fn ->
            case Podcasts.refresh_episodes(podcast) do
              {:ok, %{podcast: podcast}} ->
                podcast
                |> Podcasts.list_episodes(user: conn.assigns.current_user)
                |> PocaWeb.ResourceJSON.render()

              {:error, _} ->
                []
            end
          end)
        )
        |> render_inertia("Podcast")
    end
  end
end
