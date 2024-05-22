defmodule ObjectiveChallengeWeb.AccountJSONTest do
  use ExUnit.Case, async: true
  alias ObjectiveChallenge.Bank.Account
  alias ObjectiveChallengeWeb.AccountJSON

  describe "show/1" do
    test "returns the correct JSON representation of an account" do
      account = %Account{account_number: "12345", balance: 1000.00}

      expected_result = %{
        numero_conta: "12345",
        saldo: 1000.00
      }

      assert AccountJSON.show(%{account: account}) == expected_result
    end
  end
end
