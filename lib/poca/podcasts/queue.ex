defmodule Poca.Podcasts.Queue do
  use Ecto.Schema
  import Ecto.Changeset

  alias Poca.{Accounts, Podcasts}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "queues" do
    belongs_to :user, Accounts.User

    has_many :queue_entries, Podcasts.QueueEntry
    has_many :episodes, through: [:queue_entries, :episode]

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(queue, attrs) do
    queue
    |> cast(attrs, [])
    |> validate_required([])
    |> unique_constraint(:user_id, name: "queues_user_id_index")
  end
end
