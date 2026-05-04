defmodule PocaWeb.Components.ComponentsTest do
  use Poca.DataCase, async: true

  import Phoenix.LiveViewTest
  import Ecto.Query

  alias PocaWeb.Components
  alias Poca.Podcasts
  alias Poca.Podcasts.{Episode, Playback}

  describe "playback_progress/1" do
    setup do
      {:ok, %{user: user}} = Fixtures.signup_user(%{})
      {:ok, %{podcast: podcast}} = Fixtures.create_podcast(%{artwork_url: "https://example.com/artwork.jpg"})
      {:ok, %{episode: episode}} = Fixtures.create_episode(podcast, %{duration: 512})
      {:ok, _} = Podcasts.save_playback_progress(user, episode, 128, episode.duration)

      episode =
        Episode
        |> join(:inner, [e], p in Playback, on: p.episode_id == e.id and p.user_id == ^user.id, as: :playback)
        |> where([e], e.id == ^episode.id)
        |> preload([e, playback: p], playback: p)
        |> Repo.one!()

      {:ok, %{user: user, episode: episode}}
    end

    test "show progressbar", %{episode: episode} do
      html = render_component(&Components.playback_progress/1, %{episode: episode}) |> LazyHTML.from_fragment()

      assert html |> LazyHTML.text() |> String.trim() == "8:32"
      assert html |> LazyHTML.query("[data-testid='progress']") |> LazyHTML.attribute("style") == ["width: 25%"]
    end
  end
end
