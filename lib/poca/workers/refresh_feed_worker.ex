defmodule Poca.RefreshFeedWorker do
  use Oban.Worker, queue: :default

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

    {:ok, nil}
  end
end
