defmodule PocaWeb.PlaybackController do
  use PocaWeb, :controller

  alias Poca.Podcasts

  def update(conn, %{"duration" => nil}) do
    conn |> json(%{})
  end

  def update(conn, params = %{"episode_id" => episode_id}) do
    %{"currentTime" => current_time, "duration" => duration} = params

    current_user = conn.assigns.current_user
    episode = Podcasts.get_episode(episode_id)

    {:ok, %{playback: playback}} = Podcasts.save_playback_progress(current_user, episode, current_time, duration)

    conn |> json(PocaWeb.ResourceJSON.render(playback))
  end
end
