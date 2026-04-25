defmodule Poca.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :podcast_id, references(:podcasts, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:subscriptions, [:user_id, :podcast_id], name: "subscriptions_user_id_podcast_id_index")
  end
end
