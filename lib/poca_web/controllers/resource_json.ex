defmodule PocaWeb.ResourceJSON do
  @moduledoc """
  This module is invoked by your endpoint in case of errors on JSON requests.

  See config/config.exs.
  """

  alias Poca.Podcasts

  def render(list) when is_list(list) do
    Enum.map(list, &render/1)
  end

  def render(nil), do: nil

  def render(episode = %Podcasts.Episode{}) do
    %{
      id: episode.id,
      guid: episode.guid,
      title: episode.title,
      description: episode.description,
      audio_url: episode.audio_url,
      duration: episode.duration,
      published_at: DateTime.to_iso8601(episode.published_at),
      podcast: render(episode.podcast),
      playback: render(episode.playback)
    }
  end

  def render(podcast = %Podcasts.Podcast{}) do
    %{
      id: podcast.id,
      title: podcast.title,
      author: podcast.author,
      description: podcast.description,
      link: podcast.link,
      artwork_url: podcast.artwork_url
    }
  end

  def render(playback = %Podcasts.Playback{}) do
    %{
      id: playback.id,
      current_time: playback.current_time,
      duration: playback.duration,
      progress: Podcasts.Playback.progress(playback)
    }
  end
end
