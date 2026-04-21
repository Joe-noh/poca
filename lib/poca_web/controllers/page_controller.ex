defmodule PocaWeb.PageController do
  use PocaWeb, :controller

  def home(conn, _params) do
    if conn.assigns.current_user do
      redirect(conn, to: ~p"/listen")
    else
      render(conn, :home)
    end
  end
end
