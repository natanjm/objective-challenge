defmodule ObjectiveChallenge.BankTest do
  use ObjectiveChallenge.DataCase, async: true
  alias ObjectiveChallenge.Bank
  alias ObjectiveChallenge.Bank.Account
  alias ObjectiveChallenge.Error
  alias ObjectiveChallenge.Repo

  describe "create_account/1" do
    test "creates an account with valid parameters" do
      params = %{account_number: 123_456, balance: 1000.0}
      response = Bank.create_account(params)
      assert {:ok, %Account{account_number: 123_456, balance: 1000.0}} = response
    end

    test "returns an error with invalid parameters" do
      params = %{some_field: 123_456}
      response = Bank.create_account(params)

      assert {
               :error,
               %ObjectiveChallenge.Error{
                 status: :bad_request,
                 result: %Ecto.Changeset{
                   errors: [
                     account_number: {"can't be blank", [validation: :required]},
                     balance: {"can't be blank", [validation: :required]}
                   ],
                   valid?: false
                 }
               }
             } = response
    end

    test "returns an error if exists an account with the same number" do
      params = %{account_number: 123_456, balance: 1000.0}
      Bank.create_account(params)
      response = Bank.create_account(params)

      assert {
               :error,
               %ObjectiveChallenge.Error{
                 result: %Ecto.Changeset{
                   errors: [
                     account_number:
                       {"has already been taken",
                        [constraint: :unique, constraint_name: "unique_account_number_index"]}
                   ],
                   valid?: false
                 },
                 status: :bad_request
               }
             } = response
    end
  end

  describe "get_account_by_number/1" do
    test "retrieves an account by number" do
      account = %Account{account_number: 123_456, balance: 1000.0}
      Repo.insert!(account)

      response = Bank.get_account_by_number(123_456)
      assert {:ok, %Account{account_number: 123_456, balance: 1000.0}} = response
    end

    test "returns an error if account is not found" do
      response = Bank.get_account_by_number(999_999)
      assert {:error, %Error{status: :not_found, result: "account not found"}} = response
    end
  end

  describe "create_transaction/1" do
    setup do
      account = %Account{account_number: 123_456, balance: 1000.0}
      {:ok, account: Repo.insert!(account)}
    end

    test "creates a transaction with a PIX payment method", %{
      account: %{account_number: account_number}
    } do
      params = %{account_number: account_number, value: 100.0, payment_method: "P"}
      response = Bank.create_transaction(params)

      assert {:ok, %Account{account_number: ^account_number, balance: 900.0}} = response
    end

    test "creates a transaction with a debit payment method", %{
      account: %{account_number: account_number}
    } do
      params = %{account_number: account_number, value: 100.0, payment_method: "D"}
      response = Bank.create_transaction(params)

      assert {:ok, %Account{account_number: ^account_number, balance: 897.0}} = response
    end

    test "creates a transaction with a credit payment method", %{
      account: %{account_number: account_number}
    } do
      params = %{account_number: account_number, value: 100.0, payment_method: "C"}
      response = Bank.create_transaction(params)

      assert {:ok, %Account{account_number: ^account_number, balance: 895.0}} = response
    end

    test "returns an error with invalid parameters", %{account: %{account_number: account_number}} do
      params = %{account_number: account_number, value: 100.0, payment_method: "X"}
      response = Bank.create_transaction(params)

      assert {:error, %Error{result: "invalid payment method", status: :bad_request}} = response
    end

    test "returns an error if the account does not have enough balance", %{
      account: %{account_number: account_number}
    } do
      params = %{account_number: account_number, value: 2000.0, payment_method: "D"}
      response = Bank.create_transaction(params)

      assert {:error, %Error{result: "insufficient balance", status: 404}} = response
    end

    test "returns an error if value is not a number", %{
      account: %{account_number: account_number}
    } do
      params = %{account_number: account_number, value: "some_value", payment_method: "D"}
      response = Bank.create_transaction(params)

      assert {:error, %Error{result: "value is not a number", status: :bad_request}} = response
    end

    test "returns an error if any parameter is forgotten", %{
      account: %{account_number: account_number}
    } do
      params = %{account_number: account_number, value: "some_value"}
      response = Bank.create_transaction(params)

      assert {:error, %Error{result: "invalid params", status: :bad_request}} = response
    end
  end
end
