defmodule PocaWeb.PodcastLive.ListenTest do
  use PocaWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "/listen" do
    setup do
      {:ok, user} = Poca.Accounts.signup_with_google("12345")
      %{user: user}
    end

    test "renders listen page", %{conn: conn, user: user} do
      assert {:ok, _lv, _html} =
               conn
               |> login_user(user)
               |> live(~p"/listen")
    end

    test "redirects if user is not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"/listen")
      assert {:redirect, %{to: "/"}} = redirect
    end
  end
end
