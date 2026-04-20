defmodule PocaWeb.AuthController do
  use PocaWeb, :controller

  plug Ueberauth

  alias Ueberauth.Strategy.Helpers
  alias Poca.Accounts

  def request(conn, _params) do
    render(conn, callback_url: Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    with %Ueberauth.Auth{provider: :google, uid: uid} = auth,
         {:ok, user} <- Accounts.signup_with_google(uid) do
      conn
      |> put_session(:user_id, user.id)
      |> redirect(to: ~p"/listen")
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _}} = conn, _params) do
    redirect(conn, to: ~p"/")
  end
end
