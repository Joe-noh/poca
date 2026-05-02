defmodule PocaWeb.PodcastLive.ListenTest do
  use PocaWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias Poca.Podcasts

  describe "/listen" do
    setup do
      {:ok, %{user: user}} = Fixtures.signup_user(%{})
      {:ok, %{podcast: podcast}} = Fixtures.create_podcast(%{artwork_url: "https://example.com/artwork.jpg"})

      {:ok, %{episode: episode}} =
        Fixtures.create_episode(podcast, %{
          title: "Happy new year!",
          duration: 512
        })

      {:ok, _} = Podcasts.subscribe(podcast, user)

      {:ok, %{user: user, podcast: podcast, episode: episode}}
    end

    test "renders subscribed episodes", %{conn: conn, user: user, episode: episode} do
      {:ok, view, _html} = conn |> put_connect_params(%{"viewport" => %{"width" => 720}}) |> login_user(user) |> live(~p"/listen")

      episode_html = render_async(view) |> LazyHTML.from_fragment() |> LazyHTML.query("#episode-#{episode.id}")

      assert episode_html |> LazyHTML.query("img") |> LazyHTML.attribute("src") == ["https://example.com/artwork.jpg"]
      assert episode_html |> LazyHTML.text() =~ ~r/Happy new year!/
      assert episode_html |> LazyHTML.text() =~ ~r/8:32/
    end

    test "can play an episode", %{conn: conn, user: user, episode: %{id: episode_id}} do
      {:ok, view, _html} = conn |> put_connect_params(%{"viewport" => %{"width" => 720}}) |> login_user(user) |> live(~p"/listen")

      view
      |> element("#episode-#{episode_id}")
      |> render_click()

      assert_receive {_, {:push_event, "play_audio", %{id: ^episode_id, current_time: 0}}}
    end

    test "redirects if user is not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"/listen")
      assert {:redirect, %{to: "/"}} = redirect
    end
  end
end
