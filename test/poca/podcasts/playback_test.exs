defmodule Poca.Podcasts.PlaybackTest do
  use Poca.DataCase, async: true

  alias Poca.Podcasts.Playback

  describe "progress/1" do
    test "returns progress in percentage" do
      assert Playback.progress(%Playback{current_time: 3600, duration: 3600}) == 100
      assert Playback.progress(%Playback{current_time: 1200, duration: 3600}) == 33
      assert Playback.progress(%Playback{current_time: 0, duration: 3600}) == 0
      assert Playback.progress(%Playback{current_time: 1800, duration: 0}) == 0
    end
  end
end
