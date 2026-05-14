defmodule PocaWeb.PageController do
  use PocaWeb, :controller

  def home(conn, _params) do
    if conn.assigns.current_user do
      redirect(conn, to: ~p"/listen")
    else
      render(conn, :home)
    end
  end

  def spa(conn, _params) do
    render(conn, :spa)
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
