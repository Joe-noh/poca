defmodule Poca.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Poca.Repo

  alias Poca.Accounts.{User, SocialAccount}
  alias Poca.Podcasts

  def get_user(nil), do: nil
  def get_user(id), do: User |> where([u], u.id == ^id) |> Repo.one()

  def get_user_by_google_uid(uid) do
    User
    |> join(:inner, [u], sa in assoc(u, :social_accounts))
    |> where([_u, sa], sa.provider == "google" and sa.uid == ^uid)
    |> preload([_u, sa], google_account: sa)
    |> Repo.one()
  end

  def login_with_google(uid) do
    case get_user_by_google_uid(uid) do
      nil -> {:error, :user_not_found}
      user -> {:ok, %{user: user}}
    end
  end

  def signup_with_google(uid) do
    with {:existing, nil} <- {:existing, get_user_by_google_uid(uid)},
         {:ok, user} <- do_signup_with_google(uid) do
      {:ok, %{user: user}}
    else
      {:existing, user} -> {:ok, %{user: user}}
    end
  end

  defp do_signup_with_google(uid) do
    Repo.transact(fn ->
      with {:ok, user} <- User.changeset(%User{}, %{}) |> Repo.insert(),
           changeset = user |> Ecto.build_assoc(:social_accounts) |> SocialAccount.changeset(%{provider: "google", uid: uid}),
           {:ok, _account} <- Repo.insert(changeset),
           {:ok, _queue} <- Podcasts.create_queue(user) do
        {:ok, user}
      end
    end)
  end
end
