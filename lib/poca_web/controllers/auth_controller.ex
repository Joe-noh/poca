defmodule PocaWeb.AuthController do
  use PocaWeb, :controller

  plug Ueberauth

  alias Ueberauth.Strategy.Helpers

  def request(conn, _params) do
    render(conn, callback_url: Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    %Ueberauth.Auth{provider: :google, uid: uid} = auth

    redirect(conn, to: ~p"/listen")
  end

  def callback(%{assigns: %{ueberauth_failure: _}} = conn, _params) do
    redirect(conn, to: ~p"/")
  end
end
