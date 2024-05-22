defmodule ObjectiveChallengeWeb.ErrorJSONTest do
  use ObjectiveChallengeWeb.ConnCase, async: true

  alias ObjectiveChallengeWeb.ErrorJSON
  alias ObjectiveChallenge.Bank.Account

  describe "error/1" do
    test "when the result is not a changeset error" do
      response = ErrorJSON.error(%{result: "invalid parameter"})
      expected_response = %{message: "invalid parameter"}
      assert expected_response == response
    end

    test "when the result is a changeset error" do
      response = ErrorJSON.error(%{result: Account.changeset(%{})})

      expected_response = %{
        mesage: %{account_number: ["can't be blank"], balance: ["can't be blank"]}
      }

      assert expected_response == response
    end
  end
end
