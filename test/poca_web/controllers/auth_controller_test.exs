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

    assert get_session(conn, :user_id) |> is_nil()
    assert redirected_to(conn) == ~p"/"
  end

  describe "DELETE /auth/logout" do
    setup :register_and_login_user

    test "logs out the user", %{conn: conn} do
      conn = conn |> delete(~p"/auth/logout")

      assert get_session(conn, :user_id) == nil
      assert redirected_to(conn) == ~p"/"
    end
  end
end
