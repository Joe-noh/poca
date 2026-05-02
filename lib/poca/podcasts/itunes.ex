defmodule Poca.Podcasts.Itunes do
  @moduledoc """
  Module for searching podcasts on iTunes.
  """

  defmodule Entry do
    @moduledoc false

    defstruct [
      :artist_name,
      :artwork_url_30,
      :artwork_url_60,
      :artwork_url_100,
      :artwork_url_600,
      :collection_id,
      :collection_name,
      :feed_url,
      :genres,
      :kind,
      :primary_genre_name,
      :track_count
    ]
  end

  def search(query) do
    [
      url: "https://itunes.apple.com/search",
      params: [term: query, media: "podcast", entity: "podcast", limit: 120],
      receive_timeout: 5_000
    ]
    |> Keyword.merge(Application.get_env(:poca, :itunes_req_opts, []))
    |> Req.request()
    |> case do
      {:ok, response} ->
        {:ok, build_entries(response)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp build_entries(response) do
    response.body
    |> Jason.decode!()
    |> Map.get("results", [])
    |> Enum.map(&build_entry/1)
  end

  defp build_entry(entry) do
    %Entry{
      artist_name: entry["artistName"],
      artwork_url_30: entry["artworkUrl30"],
      artwork_url_60: entry["artworkUrl60"],
      artwork_url_100: entry["artworkUrl100"],
      artwork_url_600: entry["artworkUrl600"],
      collection_id: entry["collectionId"],
      collection_name: entry["collectionName"],
      feed_url: entry["feedUrl"],
      genres: entry["genres"],
      kind: entry["kind"],
      primary_genre_name: entry["primaryGenreName"],
      track_count: entry["trackCount"]
    }
  end
end
