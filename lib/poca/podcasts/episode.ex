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

  def format_duration(%__MODULE__{duration: duration}) do
    hours = div(duration, 3600)
    minutes = div(rem(duration, 3600), 60)
    seconds = rem(duration, 60)

    cond do
      hours > 0 -> "#{hours}:#{pad_zero(minutes)}:#{pad_zero(seconds)}"
      minutes > 0 -> "#{minutes}:#{pad_zero(seconds)}"
      true -> "0:#{pad_zero(seconds)}"
    end
  end

  def format_duration(_), do: "0:00"

  defp pad_zero(value) when value < 10, do: "0#{value}"
  defp pad_zero(value), do: "#{value}"
end
