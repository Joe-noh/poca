defmodule PocaWeb.AuthController do
  use PocaWeb, :controller

  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias Poca.Accounts
  alias PocaWeb.UserAuth

  def request(conn, _params) do
    render(conn, callback_url: Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    %Ueberauth.Auth{provider: :google, uid: uid} = auth

    case(Accounts.login_with_google(uid)) do
      {:ok, %{user: user}} ->
        conn |> UserAuth.login_user(user)

      {:error, _} ->
        conn |> redirect(to: ~p"/")
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _}} = conn, _params) do
    redirect(conn, to: ~p"/")
  end

  def delete(conn, _params) do
    conn |> UserAuth.logout_user()
  end
end
