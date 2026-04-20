defmodule PocaWeb.AuthControllerTest do
  use PocaWeb.ConnCase

  test "GET /auth/google", %{conn: conn} do
    conn = get(conn, ~p"/auth/google")

    assert redirected_to(conn) |> String.starts_with?("https://accounts.google.com")
  end

  test "GET /auth/google/callback", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, %Ueberauth.Auth{provider: :google, uid: "12345"})
      |> get(~p"/auth/google/callback")

    assert get_session(conn, :user_id) |> is_binary()
    assert redirected_to(conn) == ~p"/listen"
  end
end
