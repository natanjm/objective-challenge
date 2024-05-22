defmodule ObjectiveChallengeWeb.TransactionControllerTest do
  use ObjectiveChallengeWeb.ConnCase, async: true
  # use ObjectiveChallenge.DataCase, async: true

  alias ObjectiveChallenge.Bank.Account
  alias ObjectiveChallenge.Repo

  setup do
    account = %Account{account_number: 123, balance: 1000.0}
    {:ok, account: Repo.insert!(account)}
  end

  describe "create/2" do
    test "if all parameters are correct, a transaction should be created", %{
      conn: conn,
      account: account
    } do
      params = %{
        "numero_conta" => account.account_number,
        "valor" => 100.0,
        "forma_pagamento" => "P"
      }

      response =
        post(conn, "/api/transacao", params)
        |> json_response(201)

      expected_response = %{"numero_conta" => 123, "saldo" => 900.0}
      assert expected_response == response
    end

    test "returns an error with invalid payment method", %{conn: conn, account: account} do
      params = %{
        "numero_conta" => account.account_number,
        "valor" => 100.0,
        "forma_pagamento" => "X"
      }

      response =
        post(conn, "/api/transacao", params)
        |> json_response(400)

      assert %{"message" => "invalid payment method"} == response
    end

    test "returns an error if the account does not have enough balance", %{
      conn: conn,
      account: account
    } do
      params = %{
        "numero_conta" => account.account_number,
        "valor" => 2000.0,
        "forma_pagamento" => "D"
      }

      response =
        post(conn, "/api/transacao", params)
        |> json_response(404)

      expected_response = %{"message" => "insufficient balance"}
      assert expected_response == response
    end

    test "returns an error if the provided account number does not exists", %{conn: conn} do
      some_account_number = 9999

      params = %{
        "numero_conta" => some_account_number,
        "valor" => 2000.0,
        "forma_pagamento" => "D"
      }

      response =
        post(conn, "/api/transacao", params)
        |> json_response(404)

      expected_response = %{"message" => "account not found"}
      assert expected_response == response
    end
  end
end
