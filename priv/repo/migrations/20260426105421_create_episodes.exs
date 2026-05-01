defmodule Poca.Repo.Migrations.CreateEpisodes do
  use Ecto.Migration

  def change do
    create table(:episodes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :podcast_id, references(:podcasts, on_delete: :delete_all, type: :binary_id), null: false
      add :guid, :string
      add :title, :string
      add :description, :text
      add :audio_url, :text, null: false
      add :duration, :integer, null: false
      add :published_at, :utc_datetime_usec

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:episodes, [:podcast_id, :guid], name: "episodes_podcast_id_guid_index")
  end
end
