defmodule Poca.Podcasts.QueueEntry do
  use Ecto.Schema
  import Ecto.Changeset

  alias Poca.Podcasts

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "queue_entries" do
    belongs_to :queue, Podcasts.Queue
    belongs_to :episode, Podcasts.Episode

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(queue_entry, attrs) do
    queue_entry
    |> cast(attrs, [:position])
    |> validate_required([:position])
    |> unique_constraint(:episode_id, name: "queue_entries_queue_id_episode_id_index")
  end
end
