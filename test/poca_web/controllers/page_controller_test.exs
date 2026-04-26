defmodule PocaWeb.PageControllerTest do
  use PocaWeb.ConnCase

  describe "GET /" do
    setup do
      Poca.Accounts.signup_with_google("12345")
    end

    test "renders home page", %{conn: conn} do
      conn = conn |> get(~p"/")

      assert html_response(conn, 200) =~ "POCA"
    end

    test "redirects to listen if user is logged in", %{conn: conn, user: user} do
      conn = conn |> login_user(user) |> get(~p"/")

      assert redirected_to(conn) == ~p"/listen"
    end
  end
end
