defmodule Poca.Podcasts.Episode do
  use Ecto.Schema
  import Ecto.Changeset

  alias Poca.Podcasts.{Podcast, Playback}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "episodes" do
    field :guid, :string
    field :title, :string
    field :description, :string
    field :audio_url, :string
    field :duration, :integer
    field :published_at, :utc_datetime_usec

    has_one :playback, Playback
    has_many :playbacks, Playback

    belongs_to :podcast, Podcast

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(episode, attrs) do
    episode
    |> cast(attrs, [:guid, :title, :description, :audio_url, :duration, :published_at, :podcast_id])
    |> validate_required([:audio_url, :duration, :podcast_id])
  end
end
