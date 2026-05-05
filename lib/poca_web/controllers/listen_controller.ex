defmodule PocaWeb.ListenController do
  use PocaWeb, :controller

  def index(conn, _params) do
    conn
    |> assign_prop(:name, "John")
    |> render_inertia("Listen")
  end
end
