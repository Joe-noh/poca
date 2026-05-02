defmodule Poca.Podcasts.EpisodeTest do
  use Poca.DataCase, async: true

  alias Poca.Podcasts.Episode

  describe "format_duration/1" do
    test "formats duration to string" do
      assert Episode.format_duration(%Episode{duration: 3600}) == "1:00:00"
      assert Episode.format_duration(%Episode{duration: 1821}) == "30:21"
      assert Episode.format_duration(%Episode{duration: 59}) == "0:59"
      assert Episode.format_duration(%Episode{duration: 0}) == "0:00"
    end
  end
end
