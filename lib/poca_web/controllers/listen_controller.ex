defmodule PocaWeb.ListenController do
  use PocaWeb, :controller

  def index(conn, _params) do
    conn
    |> assign_prop(:episodes, [])
    |> assign_prop(:active_tab, "listen")
    |> render_inertia("Listen")
  end
end
