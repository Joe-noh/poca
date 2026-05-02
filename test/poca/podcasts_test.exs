defmodule Poca.PodcastsTest do
  use Poca.DataCase, async: true

  alias Poca.Fixtures
  alias Poca.Podcasts
  alias Poca.Podcasts.Podcast

  describe "refresh_podcast/2" do
    setup do
      Req.Test.stub(Poca.Podcasts.FeedTestPlug, fn conn ->
        Req.Test.text(conn, Fixtures.feed_fixture())
      end)

      Poca.Accounts.signup_with_google("12345")
    end

    test "fetches and updates podcast feed data" do
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
    setup do
      {:ok, %{user: user}} = Fixtures.signup_user(%{})
      {:ok, %{podcast: podcast}} = Fixtures.create_podcast(%{})

      {:ok, %{user: user, podcast: podcast}}
    end

    test "inserts a subscription record", %{user: user, podcast: podcast} do
      assert {:ok, %{subscription: subscription}} = Podcasts.subscribe(podcast, user)
      assert subscription.podcast_id == podcast.id
      assert subscription.user_id == user.id

      assert %Podcast{subscribers: [^user]} = Podcasts.get_podcast(podcast.id, user: user)
    end
  end

  describe "unsubscribe/1" do
    setup do
      {:ok, %{user: user}} = Fixtures.signup_user(%{})
      {:ok, %{podcast: podcast}} = Fixtures.create_podcast(%{})

      {:ok, %{user: user, podcast: podcast}}
    end

    test "deletes the subscription record", %{user: user, podcast: podcast} do
      assert {:ok, %{subscription: _subscription}} = Podcasts.subscribe(podcast, user)
      assert {:ok, _} = Podcasts.unsubscribe(podcast, user)

      assert %Podcast{subscribers: []} = Podcasts.get_podcast(podcast.id, user: user)
    end
  end

  describe "subscribed_episodes/1" do
    setup do
      {:ok, %{user: user}} = Fixtures.signup_user(%{})
      {:ok, %{podcast: podcast}} = Fixtures.create_podcast(%{})
      {:ok, %{episode: episode}} = Fixtures.create_episode(%{podcast: podcast})

      {:ok, %{user: user, podcast: podcast, episode: episode}}
    end

    setup %{user: user, podcast: podcast} do
      Podcasts.subscribe(podcast, user)
    end

    test "returns episodes from subscribed podcasts", %{user: user, podcast: podcast, episode: episode} do
      {:ok, %{episodes: [subscribed]}} = Podcasts.subscribed_episodes(user)

      assert subscribed.id == episode.id
      assert subscribed.podcast.id == podcast.id
    end
  end
end
