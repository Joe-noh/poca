defmodule Poca.PodcastsTest do
  use Poca.DataCase, async: true

  alias Poca.Fixtures
  alias Poca.{Podcasts, Accounts}
  alias Poca.Podcasts.Podcast

  describe "refresh_podcast/2" do
    setup do
      feed = Fixtures.feed_fixture()
      Req.Test.stub(Poca.Podcasts.FeedTestPlug, fn conn -> Req.Test.text(conn, feed) end)

      {:ok, %{user: user}} = Poca.Accounts.signup_with_google("12345")

      {:ok, %{user: user, feed: feed}}
    end

    test "fetches and updates podcast feed data", %{feed: feed} do
      {:ok, %{podcast: podcast}} = Podcasts.create_podcast(%{"feed_url" => "http://example.com/feed"})
      {:ok, %{podcast: podcast}} = Podcasts.refresh_podcast(podcast)

      assert %{
               title: "I am Mr. Talk",
               author: "Mr. Talk",
               description: "Welcome to Mr. Talk's podcast, where we dive into the world of self-improvement to becoming the best version of yourself.",
               link: "https://example.com",
               artwork_url: "https://example.com/thumbnail.jpg"
             } = podcast
    end
  end

  describe "subscribe/1" do
    setup [:signup_user, :create_podcast]

    test "inserts a subscription record", %{user: user, podcast: podcast} do
      assert {:ok, %{subscription: subscription}} = Podcasts.subscribe(podcast, user)
      assert subscription.podcast_id == podcast.id
      assert subscription.user_id == user.id

      assert %Podcast{subscribers: [^user]} = Podcasts.get_podcast(podcast.id, user: user)
    end
  end

  describe "unsubscribe/1" do
    setup [:signup_user, :create_podcast]

    test "deletes the subscription record", %{user: user, podcast: podcast} do
      assert {:ok, %{subscription: _subscription}} = Podcasts.subscribe(podcast, user)
      assert {:ok, _} = Podcasts.unsubscribe(podcast, user)

      assert %Podcast{subscribers: []} = Podcasts.get_podcast(podcast.id, user: user)
    end
  end

  describe "subscribed_episodes/1" do
    setup [:signup_user, :create_podcast, :create_episode]

    setup %{user: user, podcast: podcast} do
      Podcasts.subscribe(podcast, user)
    end

    test "returns episodes from subscribed podcasts", %{user: user, podcast: podcast, episode: episode} do
      episodes = Podcasts.subscribed_episodes(user)

      assert [episode] = episodes
      assert Enum.all?(episodes, fn e -> e.podcast == podcast end)
    end
  end

  defp signup_user(_) do
    Accounts.signup_with_google("12345")
  end

  defp create_podcast(_) do
    Podcasts.create_podcast(%{"feed_url" => "http://example.com/feed"})
  end

  defp create_episode(%{podcast: podcast}) do
    {:ok, episode} =
      podcast
      |> Ecto.build_assoc(:episodes)
      |> Ecto.Changeset.change(%{
        guid: Ecto.UUID.generate(),
        title: "Episode title",
        description: "Episode description",
        audio_url: "http://example.com/audio.mp3",
        duration: 3600,
        published_at: DateTime.utc_now()
      })
      |> Poca.Repo.insert()

    {:ok, %{episode: episode}}
  end
end
