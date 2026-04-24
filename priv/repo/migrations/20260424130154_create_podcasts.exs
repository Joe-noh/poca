defmodule Poca.Repo.Migrations.CreatePodcasts do
  use Ecto.Migration

  def change do
    create table(:podcasts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :author, :string
      add :description, :string
      add :link, :string
      add :feed_url, :string, null: false
      add :artwork_url, :string
      add :last_fetched_at, :utc_datetime_usec

      timestamps(type: :utc_datetime_usec)
    end
  end
end
