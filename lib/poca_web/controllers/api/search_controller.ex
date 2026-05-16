defmodule PocaWeb.Api.SearchController do
  use PocaWeb, :controller

  alias Poca.Podcasts

  def create(conn, %{"q" => q}) do
    conn |> search(q)
  end

  defp search(conn, "") do
    conn |> json(%{podcasts: []})
  end

  defp search(conn, query) do
    {:ok, results} = Podcasts.Itunes.search(query)

    podcasts =
      results
      |> Enum.map(fn %{feed_url: feed_url} ->
        Task.async(fn ->
          case Podcasts.refresh_podcast(%Podcasts.Podcast{feed_url: feed_url}) do
            {:ok, %{podcast: podcast}} -> podcast
            {:error, _} -> nil
          end
        end)
      end)
      |> Task.await_many(30_000)
      |> Enum.filter(& &1)
      |> Enum.sort_by(fn podcast -> results |> Enum.find_index(&(&1.feed_url == podcast.feed_url)) end)

    conn |> json(%{podcasts: PocaWeb.ResourceJSON.render(podcasts)})
  end
end
