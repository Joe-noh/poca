defmodule Poca.Repo.Migrations.CreatePlaybacks do
  use Ecto.Migration

  def change do
    create table(:playbacks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false
      add :episode_id, references(:episodes, on_delete: :delete_all, type: :binary_id), null: false
      add :current_time, :float, null: false
      add :duration, :float, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:playbacks, [:user_id, :episode_id], name: "playbacks_user_id_episode_id_index")
  end
end
