defmodule PocaWeb.Api.SearchController do
  use PocaWeb, :controller

  alias Poca.Podcasts

  def create(conn, %{"q" => q}) do
    conn |> search(q)
  end

  defp search(conn, query) when query == "" or is_nil(query) do
    conn |> json(%{podcasts: []})
  end

  defp search(conn, query) do
    Poca.SearchPodcastsWorker.new(%{"query" => query}) |> Oban.insert()

    podcasts = Podcasts.search_podcasts(query)

    conn |> json(%{podcasts: PocaWeb.ResourceJSON.render(podcasts)})
  end
end
