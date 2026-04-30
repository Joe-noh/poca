defmodule PocaWeb.CurrentUserPlug do
  @moduledoc """
  A plug to assign the current user to the connection based on the session.
  """

  alias Poca.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    user = conn |> Plug.Conn.get_session(:user_id) |> Accounts.get_user()

    if user do
      conn
      |> Plug.Conn.assign(:current_user, user)
      |> PocaWeb.UserAuth.create_or_extend_session(user)
    else
      Plug.Conn.assign(conn, :current_user, nil)
    end
  end
end
