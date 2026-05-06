defmodule PocaWeb.LibraryController do
  use PocaWeb, :controller

  def index(conn, _params) do
    conn
    |> assign_prop(:podcasts, [])
    |> assign_prop(:active_tab, "library")
    |> render_inertia("Library")
  end
end
