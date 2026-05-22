defmodule Poca.RefreshFeedWorker do
  @moduledoc """
  An Oban worker that refreshes podcast feeds for all subscribed podcasts.
  """

  use Oban.Worker, queue: :default, max_attempts: 3

  alias Poca.{Podcasts, Repo}

  @impl Oban.Worker
  def perform(_job) do
    Repo.transact(fn ->
      Podcasts.subscribed_podcasts()
      |> Repo.stream()
      |> Stream.each(&Podcasts.refresh_episodes/1)
      |> Stream.run()

      {:ok, []}
    end)

    :ok
  end
end
