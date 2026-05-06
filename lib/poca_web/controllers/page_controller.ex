defmodule PocaWeb.PageController do
  use PocaWeb, :controller

  def home(conn, _params) do
    if conn.assigns.current_user do
      redirect(conn, to: ~p"/listen")
    else
      render(conn, :home)
    end
  end

  def manifest(conn, _params) do
    json(conn, %{
      name: "POCA",
      short_name: "POCA",
      start_url: url(~p"/listen"),
      display: "standalone",
      background_color: "#f4f0ea",
      theme_color: "#141810",
      icons: [
        %{
          src: static_path(conn, "/images/icons/256.png"),
          sizes: "256x256",
          type: "image/png"
        }
      ]
    })
  end

  def chrome_devtools(conn, _params) do
    json(conn, %{
      workspace: %{
        root: File.cwd!(),
        uuid: "4b566e66-cc4e-449e-a191-38f70175e5ce"
      }
    })
  end
end
