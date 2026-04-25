defmodule Poca.Podcasts.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "subscriptions" do
    belongs_to :user, Poca.Accounts.User
    belongs_to :podcast, Poca.Podcasts.Podcast

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [])
    |> cast_assoc(:user)
    |> cast_assoc(:podcast)
    |> validate_required([:user_id, :podcast_id])
    |> unique_constraint(:user_podcast, name: "subscriptions_user_id_podcast_id_index")
  end
end
