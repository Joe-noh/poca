defmodule PocaWeb.ListenController do
  use PocaWeb, :controller

  alias Poca.Podcasts

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    {:ok, %{episodes: episodes}} = Podcasts.subscribed_episodes(current_user)

    conn
    |> assign_prop(:active_tab, "listen")
    |> assign_prop(:episodes, PocaWeb.ResourceJSON.render(episodes))
    |> render_inertia("Listen")
  end
end
