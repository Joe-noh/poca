defmodule PocaWeb.Api.QueueEpisodeController do
  use PocaWeb, :controller

  alias Poca.Podcasts

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    {:ok, %{episodes: episodes}} = Podcasts.list_queue_episodes(current_user)

    conn |> json(%{episodes: PocaWeb.ResourceJSON.render(episodes)})
  end
end
