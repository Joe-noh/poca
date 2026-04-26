defmodule Poca.Podcasts.Feed do
  @moduledoc """
  Module responsible for fetching and parsing podcast RSS feeds.
  """

  @doc """
  Fetches and parses the RSS feed for a given podcast.

  ## Examples

      iex> Poca.Podcasts.Feed.fetch("https://example.com/podcast/rss")
      {:ok, %FastRSS.Feed{}}
  """
  def fetch(url) do
    with {:ok, %Req.Response{status: 200, body: body}} <- get(url),
         {:ok, feed} <- FastRSS.parse(body) do
      {:ok, feed}
    else
      {:ok, %Req.Response{status: status}} ->
        {:error, "Failed to fetch feed. HTTP status: #{status}"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp get(url) do
    [url: url]
    |> Keyword.merge(Application.get_env(:poca, :feed_req_opts, []))
    |> Req.request()
  end
end
