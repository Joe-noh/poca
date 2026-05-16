defmodule PocaWeb.Api.SubscriptionController do
  use PocaWeb, :controller

  alias Poca.Podcasts

  def create(conn, %{"podcast_id" => podcast_id}) do
    case Podcasts.get_podcast(podcast_id, user: conn.assigns.current_user) do
      nil ->
        conn |> put_view(PocaWeb.ErrorJSON) |> render("404.json")

      podcast ->
        {:ok, _} = Podcasts.subscribe(podcast, conn.assigns.current_user)
        podcast = Podcasts.get_podcast(podcast_id, user: conn.assigns.current_user)

        conn |> json(%{podcast: PocaWeb.ResourceJSON.render(podcast)})
    end
  end

  def delete(conn, %{"podcast_id" => podcast_id}) do
    case Podcasts.get_podcast(podcast_id, user: conn.assigns.current_user) do
      nil ->
        conn |> put_view(PocaWeb.ErrorJSON) |> render("404.json")

      podcast ->
        {:ok, _} = Podcasts.unsubscribe(podcast, conn.assigns.current_user)
        podcast = Podcasts.get_podcast(podcast_id, user: conn.assigns.current_user)

        conn |> json(%{podcast: PocaWeb.ResourceJSON.render(podcast)})
    end
  end
end
