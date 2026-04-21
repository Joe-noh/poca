defmodule PocaWeb.PageControllerTest do
  use PocaWeb.ConnCase

  describe "GET /" do
    test "renders home page", %{conn: conn} do
      conn = conn |> get(~p"/")

      assert html_response(conn, 200) =~ "POCA"
    end

    test "redirects to listen if user is logged in", %{conn: conn} do
      {:ok, user} = Poca.Accounts.signup_with_google("12345")
      conn = conn |> login_user(user) |> get(~p"/")

      assert redirected_to(conn) == ~p"/listen"
    end
  end
end
