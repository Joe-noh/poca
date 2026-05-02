defmodule PocaWeb.PodcastLive.SearchTest do
  use PocaWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias Poca.Podcasts

  describe "/search" do
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

    setup do
      {:ok, %{user: user}} = Fixtures.signup_user(%{})
      {:ok, %{podcast: podcast}} = Fixtures.create_podcast(%{title: "Beautiful Life", artwork_url: "https://example.com/artwork.jpg"})
      {:ok, %{episode: episode}} = Fixtures.create_episode(podcast)
      {:ok, _} = Podcasts.subscribe(podcast, user)

      {:ok, %{user: user, podcast: podcast, episode: episode}}
    end

    test "renders search input", %{conn: conn, user: user} do
      {:ok, view, _html} = conn |> put_connect_params(%{"viewport" => %{"width" => 720}}) |> login_user(user) |> live(~p"/search")

      search_html = render_async(view) |> LazyHTML.from_fragment() |> LazyHTML.query("#search-form")

      assert search_html |> LazyHTML.query("input") |> LazyHTML.attribute("inputmode") == ["search"]
      assert search_html |> LazyHTML.query("input") |> LazyHTML.attribute("name") == ["query"]
    end

    test "can search podcasts", %{conn: conn, user: user} do
      {:ok, view, _html} = conn |> put_connect_params(%{"viewport" => %{"width" => 720}}) |> login_user(user) |> live(~p"/search?query=test")

      search_html = render_async(view) |> LazyHTML.from_fragment() |> LazyHTML.query("#search-result-123456")

      assert search_html |> LazyHTML.query("img") |> LazyHTML.attribute("alt") == ["Test Podcast"]
      assert search_html |> LazyHTML.query("img") |> LazyHTML.attribute("src") == ["https://example.com/podcast.jpg"]
      assert search_html |> LazyHTML.text() =~ ~r/Test Podcast/
      assert search_html |> LazyHTML.text() =~ ~r/Test Author/
    end

    test "redirects if user is not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"/search")
      assert {:redirect, %{to: "/"}} = redirect
    end
  end
end
