defmodule PocaWeb.Api.PodcastController do
  use PocaWeb, :controller

  alias Poca.Podcasts

  def show(conn, %{"id" => id}) do
    case Podcasts.get_podcast(id, user: conn.assigns.current_user) do
      nil ->
        conn |> put_view(PocaWeb.ErrorJSON) |> render("404.json")

      podcast ->
        conn |> json(%{podcast: PocaWeb.ResourceJSON.render(podcast)})
    end
  end
end
