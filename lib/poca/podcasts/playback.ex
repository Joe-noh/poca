defmodule Poca.Podcasts.Playback do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "playbacks" do
    field :current_time, :float
    field :duration, :float

    belongs_to :user, Poca.Accounts.User
    belongs_to :episode, Poca.Podcasts.Episode

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(playback, attrs) do
    playback
    |> cast(attrs, [:current_time, :duration])
    |> validate_required([:current_time, :duration])
    |> unique_constraint(:user_id, name: "playbacks_user_id_episode_id_index")
  end
end
