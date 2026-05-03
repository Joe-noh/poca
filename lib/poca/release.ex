defmodule Poca.Release do
  def migrate do
    Application.load(:poca)

    for repo <- Application.fetch_env!(:poca, :ecto_repos) do
      Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end
end
