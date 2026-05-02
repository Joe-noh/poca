defmodule PocaWeb.PodcastLive.QueueTest do
  use PocaWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias Poca.Podcasts

  describe "/queue" do
    setup do
      {:ok, %{user: user}} = Fixtures.signup_user(%{})
      {:ok, %{podcast: podcast}} = Fixtures.create_podcast(%{artwork_url: "https://example.com/artwork.jpg"})
      {:ok, %{episode: episode}} = Fixtures.create_episode(podcast)
      {:ok, _} = Podcasts.subscribe(podcast, user)

      {:ok, %{user: user, podcast: podcast, episode: episode}}
    end

    test "renders nothing for now", %{conn: conn, user: user} do
      {:ok, view, _html} = conn |> put_connect_params(%{"viewport" => %{"width" => 720}}) |> login_user(user) |> live(~p"/queue")
      assert _html = render_async(view)
    end

    test "redirects if user is not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"/queue")
      assert {:redirect, %{to: "/"}} = redirect
    end
  end
end
