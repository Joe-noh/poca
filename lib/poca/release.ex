defmodule Poca.Release do
  @moduledoc """
  Handles database migrations during deployment.
  """

  def migrate do
    Application.load(:poca)

    for repo <- Application.fetch_env!(:poca, :ecto_repos) do
      Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end
end
