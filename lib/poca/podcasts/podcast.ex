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

    field :episodes_count, :integer, virtual: true

    has_many :episodes, Poca.Podcasts.Episode
    has_many :subscriptions, Poca.Podcasts.Subscription
    has_many :subscribers, through: [:subscriptions, :user]

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(podcast, attrs) do
    podcast
    |> cast(attrs, [:title, :author, :description, :link, :feed_url, :artwork_url, :last_fetched_at])
    |> validate_required([:feed_url])
    |> unique_constraint(:feed_url, name: "podcasts_feed_url_index")
  end

  def stale?(%__MODULE__{last_fetched_at: nil}), do: true

  def stale?(%__MODULE__{last_fetched_at: last_fetched_at}) do
    # 1 hour
    DateTime.utc_now() |> DateTime.diff(last_fetched_at, :second) > 3600
  end
end
