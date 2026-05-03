defmodule Poca.Podcasts.PodcastTest do
  use Poca.DataCase, async: true

  alias Poca.Podcasts.Podcast

  describe "stale?/1" do
    test "true if last refreshed more than an hour ago" do
      now = DateTime.utc_now()

      podcast = %Podcast{last_fetched_at: DateTime.add(now, -3601, :second)}
      assert Podcast.stale?(podcast) == true

      podcast = %Podcast{last_fetched_at: DateTime.add(now, -3599, :second)}
      assert Podcast.stale?(podcast) == false
    end

    test "true if never refreshed" do
      assert Podcast.stale?(%Podcast{last_fetched_at: nil}) == true
    end
  end
end
