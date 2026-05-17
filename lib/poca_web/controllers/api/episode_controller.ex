defmodule PocaWeb.Api.EpisodeController do
  use PocaWeb, :controller

  alias Poca.Podcasts

  def index(conn, %{"podcast_id" => podcast_id}) do
    current_user = conn.assigns.current_user

    case Podcasts.get_podcast(podcast_id, user: current_user) do
      nil ->
        conn |> put_view(PocaWeb.ErrorJSON) |> render("404.json")

      podcast ->
        episodes = Podcasts.list_episodes(podcast, user: current_user)

        conn |> json(%{episodes: PocaWeb.ResourceJSON.render(episodes)})
    end
  end

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    {:ok, %{episodes: episodes}} = Podcasts.subscribed_episodes(current_user)

    conn |> json(%{episodes: PocaWeb.ResourceJSON.render(episodes)})
  end
end
