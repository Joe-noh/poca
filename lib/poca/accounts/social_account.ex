defmodule Poca.Accounts.SocialAccount do
  use Ecto.Schema
  import Ecto.Changeset

  alias Poca.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "social_accounts" do
    field :provider, :string
    field :uid, :string

    belongs_to :user, User, type: :binary_id

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(social_account, attrs) do
    social_account
    |> cast(attrs, [:provider, :uid])
    |> cast_assoc(:user)
    |> validate_required([:provider, :uid, :user_id])
  end
end
