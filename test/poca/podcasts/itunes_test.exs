defmodule Poca.Podcasts.ItunesTest do
  use Poca.DataCase, async: true

  alias Poca.Podcasts

  describe "search/2 on success" do
    setup do
      response = %{
        results: [
          %{
            collectionId: "123456",
            collectionName: "Test Podcast",
            artistName: "Test Author",
            feedUrl: "http://example.com/feed",
            artworkUrl30: "https://example.com/podcast.jpg",
            artworkUrl60: "https://example.com/podcast.jpg",
            artworkUrl100: "https://example.com/podcast.jpg",
            artworkUrl600: "https://example.com/podcast.jpg"
          }
        ]
      }

      Req.Test.stub(Poca.Podcasts.ItunesTestPlug, fn conn ->
        Req.Test.json(conn, Jason.encode!(response))
      end)
    end

    test "fetches podcasts from iTunes" do
      {:ok, [result | _]} = Podcasts.Itunes.search("test")

      assert %Podcasts.Itunes.Entry{
               artist_name: "Test Author",
               collection_id: "123456",
               collection_name: "Test Podcast",
               feed_url: "http://example.com/feed",
               artwork_url_30: "https://example.com/podcast.jpg",
               artwork_url_60: "https://example.com/podcast.jpg",
               artwork_url_100: "https://example.com/podcast.jpg",
               artwork_url_600: "https://example.com/podcast.jpg"
             } = result
    end
  end

  describe "search/2 on failure" do
    setup do
      Req.Test.stub(Poca.Podcasts.ItunesTestPlug, fn conn ->
        Req.Test.transport_error(conn, :closed)
      end)
    end

    test "returns error on request failure" do
      assert {:error, _} = Podcasts.Itunes.search("test")
    end
  end
end
