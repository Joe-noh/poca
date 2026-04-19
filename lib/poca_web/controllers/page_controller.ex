defmodule PocaWeb.PageController do
  use PocaWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
