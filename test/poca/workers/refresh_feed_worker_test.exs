defmodule Poca.Workers.RefreshFeedWorkerTest do
  use Poca.DataCase, async: true

  alias Poca.RefreshFeedWorker
  alias Poca.Podcasts

  describe "perform/1" do
    setup do
      {:ok, %{user: user}} = Fixtures.signup_user(%{})
      {:ok, %{podcast: podcast}} = Fixtures.create_podcast()
      {:ok, _} = Podcasts.subscribe(podcast, user)

      Req.Test.stub(Poca.Podcasts.FeedTestPlug, fn conn ->
        Req.Test.text(conn, Fixtures.feed_fixture())
      end)

      {:ok, %{user: user, podcast: podcast}}
    end

    test "refreshes the feed for a podcast" do
      assert Podcasts.Episode |> Repo.all() |> length == 0

      assert :ok == perform_job(RefreshFeedWorker, %{})

      assert Podcasts.Episode |> Repo.all() |> length == 1
    end

    test "update last_fetched_at for the podcast", %{podcast: podcast} do
      assert podcast.last_fetched_at == nil

      assert :ok == perform_job(RefreshFeedWorker, %{})

      updated_podcast = Repo.get(Podcasts.Podcast, podcast.id)
      assert updated_podcast.last_fetched_at != nil
    end
  end
end
