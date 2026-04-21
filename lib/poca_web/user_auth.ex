defmodule PocaWeb.UserAuth do
  @moduledoc """
  This module provides authentication and session management functions
  """

  use PocaWeb, :verified_routes

  alias Poca.Accounts

  def login_user(conn, user) do
    conn
    |> create_or_extend_session(user)
    |> Phoenix.Controller.redirect(to: ~p"/listen")
  end

  def logout_user(conn) do
    conn
    |> renew_session(nil)
    |> Phoenix.Controller.redirect(to: ~p"/")
  end

  def fetch_current_user(conn, _opts) do
    user = conn |> Plug.Conn.get_session(:user_id) |> Accounts.get_user()

    if user do
      conn
      |> Plug.Conn.assign(:current_user, user)
      |> create_or_extend_session(user)
    else
      Plug.Conn.assign(conn, :current_user, nil)
    end
  end

  defp create_or_extend_session(conn, user) do
    conn
    |> renew_session(user)
    |> Plug.Conn.put_session(:user_id, user.id)
  end

  # Do not renew session if the user is already logged in
  # to prevent CSRF errors or data being lost in tabs that are still open
  defp renew_session(conn, user) when conn.assigns.current_user.id == user.id do
    conn
  end

  defp renew_session(conn, _user) do
    Phoenix.Controller.delete_csrf_token()

    conn
    |> Plug.Conn.configure_session(renew: true)
    |> Plug.Conn.clear_session()
  end

  def on_mount(:require_login, _params, session, socket) do
    socket = Phoenix.Component.assign_new(socket, :current_user, fn -> Accounts.get_user(session["user_id"]) end)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/")}
    end
  end

  @doc """
  Plug for routes that require the user to be authenticated.
  """
  def require_login(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> Phoenix.Controller.redirect(to: ~p"/")
      |> Plug.Conn.halt()
    end
  end
end
