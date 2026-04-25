defmodule Poca.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Poca.Accounts.SocialAccount

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    has_many :social_accounts, SocialAccount, on_delete: :delete_all
    has_one :google_account, SocialAccount, where: [provider: "google"], on_delete: :delete_all

    has_many :subscriptions, Poca.Podcasts.Subscription
    has_many :subscribed_podcasts, through: [:subscriptions, :podcast]

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> validate_required([])
  end
end
