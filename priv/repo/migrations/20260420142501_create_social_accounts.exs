defmodule Poca.Repo.Migrations.CreateSocialAccounts do
  use Ecto.Migration

  def change do
    create table(:social_accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :provider, :string
      add :uid, :string
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    create index(:social_accounts, [:user_id])
    create unique_index(:social_accounts, [:provider, :uid])
  end
end
