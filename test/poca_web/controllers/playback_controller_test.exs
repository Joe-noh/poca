defmodule PocaWeb.PlaybackControllerTest do
  use PocaWeb.ConnCase, async: true

  alias Poca.Podcasts

  describe "PUT /episodes/:episode_id/playback" do
    setup do
      {:ok, %{user: user}} = Fixtures.signup_user(%{})
      {:ok, %{podcast: podcast}} = Fixtures.create_podcast()
      {:ok, %{episode: episode}} = Fixtures.create_episode(podcast)

      {:ok, %{user: user, episode: episode}}
    end

    test "updates playback progress", %{conn: conn, user: user, episode: episode} do
      conn =
        conn
        |> login_user(user)
        |> put(~p"/episodes/#{episode.id}/playback", %{currentTime: 10, duration: 100})

      assert json_response(conn, 200)
      assert %{current_time: 10.0, duration: 100.0} = Podcasts.get_playback(episode, user)
    end

    test "does not raise when duration is nil", %{conn: conn, user: user, episode: episode} do
      conn =
        conn
        |> login_user(user)
        |> put(~p"/episodes/#{episode.id}/playback", %{currentTime: 10, duration: nil})

      assert json_response(conn, 200) == %{}
      assert Podcasts.get_playback(episode, user) == nil
    end
  end
end
