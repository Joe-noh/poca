defmodule PocaWeb.PodcastLive.LibraryTest do
  use PocaWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias Poca.Podcasts

  describe "/library" do
    setup do
      {:ok, %{user: user}} = Fixtures.signup_user(%{})
      {:ok, %{podcast: podcast}} = Fixtures.create_podcast(%{title: "Beautiful Life", artwork_url: "https://example.com/artwork.jpg"})
      {:ok, %{episode: episode}} = Fixtures.create_episode(podcast)
      {:ok, _} = Podcasts.subscribe(podcast, user)

      {:ok, %{user: user, podcast: podcast, episode: episode}}
    end

    test "renders subscribed episodes", %{conn: conn, user: user, podcast: podcast} do
      {:ok, view, _html} = conn |> put_connect_params(%{"viewport" => %{"width" => 720}}) |> login_user(user) |> live(~p"/library")

      podcast_html = render_async(view) |> LazyHTML.from_fragment() |> LazyHTML.query("#podcast-#{podcast.id}")

      assert podcast_html |> LazyHTML.query("img") |> LazyHTML.attribute("src") == ["https://example.com/artwork.jpg"]
      assert podcast_html |> LazyHTML.text() =~ ~r/Beautiful Life/
    end

    test "redirects if user is not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"/library")
      assert {:redirect, %{to: "/"}} = redirect
    end
  end
end
