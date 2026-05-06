defmodule PocaWeb.SearchController do
  use PocaWeb, :controller

  def index(conn, _params) do
    conn
    |> assign_prop(:query, "")
    |> assign_prop(:active_tab, "search")
    |> render_inertia("Search")
  end
end
