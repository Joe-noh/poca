defmodule Poca.Repo.Migrations.CreateQueues do
  use Ecto.Migration

  def change do
    create table(:queues, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:queues, [:user_id], name: "queues_user_id_index")
  end
end
