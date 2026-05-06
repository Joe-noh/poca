defmodule PocaWeb.QueueController do
  use PocaWeb, :controller

  def index(conn, _params) do
    conn
    |> assign_prop(:episodes, [])
    |> assign_prop(:active_tab, "queue")
    |> render_inertia("Queue")
  end
end
