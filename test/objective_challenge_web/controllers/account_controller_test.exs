defmodule ObjectiveChallengeWeb.AccountControllerTest do
  use ObjectiveChallengeWeb.ConnCase, async: true

  alias ObjectiveChallenge.Bank.Account
  alias ObjectiveChallenge.Repo

  describe "create/2" do
    test "creates an account with valid parameters", %{conn: conn} do
      params = %{"numero_conta" => 123_456, "saldo" => 1000.0}

      response =
        post(conn, "/api/conta", params)
        |> json_response(201)

      expected_response = %{"numero_conta" => 123_456, "saldo" => 1000.0}
      assert expected_response == response
    end

    test "returns an error when parameters are not valid", %{conn: conn} do
      params = %{"some_field" => 123_456}

      response =
        post(conn, "/api/conta", params)
        |> json_response(400)

      expected_response = %{
        "mesage" => %{"account_number" => ["can't be blank"], "balance" => ["can't be blank"]}
      }

      assert expected_response == response
    end
  end

  describe "show/2" do
    setup do
      account = %Account{account_number: 123_456, balance: 1000.0}
      {:ok, account: Repo.insert!(account)}
    end

    test "retrieves an account by number", %{conn: conn, account: account} do
      response =
        get(conn, "/api/conta?numero_conta=#{account.account_number}")
        |> json_response(200)

      expected_response = %{"numero_conta" => 123_456, "saldo" => 1000.0}
      assert expected_response == response
    end

    test "returns an error if account is not found", %{conn: conn} do
      some_account_number = 1_234_111

      response =
        get(conn, "/api/conta?numero_conta=#{some_account_number}")
        |> json_response(404)

      expected_response = %{"message" => "account not found"}
      assert expected_response == response
    end
  end
end
