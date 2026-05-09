defmodule PocaWeb.RequireLoginPlug do
  @moduledoc """
  A plug to ensure the user is logged in before accessing certain routes.
  """

  def init(opts), do: opts

  def call(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    conn
    |> Phoenix.Controller.redirect(to: "/")
    |> Plug.Conn.halt()
  end

  def call(conn, _opts) do
    conn
  end
end
