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
    try do
      [url: url]
      |> Keyword.merge(Application.get_env(:poca, :feed_req_opts, []))
      |> Req.request()
    rescue
      e -> {:error, e}
    end
  end

  def parse_pub_date(pub_date) do
    pub_date
    |> DateTimeParser.parse_datetime!()
    |> Map.put(:microsecond, {0, 6})
    |> DateTime.from_naive!("Etc/UTC")
  end

  def parse_duration(nil), do: 0

  def parse_duration(duration) when is_binary(duration) do
    String.split(duration, ":")
    |> Enum.map(&String.to_integer/1)
    |> case do
      [h, m, s] -> h * 3600 + m * 60 + s
      [m, s] -> m * 60 + s
      [s] -> s
      _ -> 0
    end
  end
end
