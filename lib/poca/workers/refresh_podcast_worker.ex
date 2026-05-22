defmodule Poca.SearchPodcastsWorker do
  @moduledoc """
  Worker to search for podcasts on iTunes and refresh them in the database.
  """

  use Oban.Worker, queue: :default, max_attempts: 3

  alias Poca.Podcasts

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"query" => query}}) do
    case Podcasts.Itunes.search(query) do
      {:ok, results} ->
        results
        |> Enum.map(fn %{feed_url: feed_url} -> refresh_task(feed_url) end)
        |> Task.await_many(30_000)

        :ok

      {:error, _} ->
        {:error, :retry}
    end
  end

  defp refresh_task(feed_url) do
    Task.async(fn ->
      case Podcasts.refresh_podcast(%Podcasts.Podcast{feed_url: feed_url}) do
        {:ok, %{podcast: podcast}} -> Podcasts.refresh_episodes(podcast)
        {:error, _} -> nil
      end
    end)
  end
end
