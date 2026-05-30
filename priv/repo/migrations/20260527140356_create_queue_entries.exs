defmodule Poca.Repo.Migrations.CreateQueueEntries do
  use Ecto.Migration

  def change do
    create table(:queue_entries, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :queue_id, references(:queues, type: :binary_id, on_delete: :delete_all), null: false
      add :episode_id, references(:episodes, type: :binary_id, on_delete: :delete_all), null: false
      add :position, :integer, null: false, default: 0

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:queue_entries, [:queue_id, :episode_id], name: "queue_entries_queue_id_episode_id_index")
    create index(:queue_entries, [:queue_id, :position])
  end
end
