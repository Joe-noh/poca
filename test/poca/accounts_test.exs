defmodule Poca.AccountsTest do
  use Poca.DataCase, async: true

  alias Poca.Accounts
  alias Poca.Accounts.User

  describe "signup_with_google/1" do
    test "creates a user and social account" do
      assert {:ok, %User{id: user_id}} = Accounts.signup_with_google("12345")

      user = Accounts.get_user_by_google_uid("12345")
      account = user.google_account

      assert account.provider == "google"
      assert account.uid == "12345"
      assert account.user_id == user_id
    end
  end
end
