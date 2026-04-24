defmodule Poca.Podcasts.Podcast do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "podcasts" do
    field :title, :string
    field :author, :string
    field :description, :string
    field :link, :string
    field :feed_url, :string
    field :artwork_url, :string
    field :last_fetched_at, :utc_datetime_usec

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(podcast, attrs) do
    podcast
    |> cast(attrs, [:title, :author, :description, :link, :feed_url, :artwork_url, :last_fetched_at])
    |> validate_required([:feed_url])
  end
end
