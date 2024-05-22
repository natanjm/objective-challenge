defmodule ObjectiveChallenge.Bank do
  alias ObjectiveChallenge.Bank.{Account, Transaction}
  alias ObjectiveChallenge.Error
  alias ObjectiveChallenge.Repo

  @debit_fee 0.03
  @credit_fee 0.05
  @pix_fee 0

  @type create_account_input :: %{
          account_number: integer(),
          balance: float()
        }

  @spec create_account(create_account_input()) :: {:ok, %Account{}} | {:error, %Error{}}
  def create_account(params) do
    Account.changeset(params)
    |> Repo.insert()
    |> case do
      {:ok, response} -> {:ok, response}
      {:error, reason} -> {:error, Error.build(:bad_request, reason)}
    end
  end

  @spec get_account_by_number(integer()) :: {:ok, %Account{}} | {:error, %Error{}}
  def get_account_by_number(account_number) do
    case Repo.get_by(Account, %{account_number: account_number}) do
      %Account{} = account -> {:ok, account}
      nil -> {:error, Error.build(:not_found, "account not found")}
    end
  end

  @type create_transaction_input :: %{
          account_number: integer(),
          value: number(),
          payment_method: String.t()
        }

  @spec create_transaction(create_transaction_input()) ::
          {:ok, %Account{}} | {:error, atom() | Ecto.Changeset.t()}
  def create_transaction(
        %{account_number: account_number, value: value, payment_method: _} = params
      ) do
    with {:ok, account} <- get_account_by_number(account_number),
         fee when is_number(fee) <- calculate_fee(params) do
      new_balance = account.balance - value - fee

      if new_balance < 0 do
        {:error, Error.build(404, "insufficient balance")}
      else
        insert_transaction_multi(%{value: value, fee: fee, account_id: account.id})
        |> update_account_balance_multi(account, new_balance)
        |> Repo.transaction()
        |> handle_create_transaction_response()
      end
    end
  end

  def create_transaction(_), do: {:error, Error.build(:bad_request, "invalid params")}

  defp calculate_fee(%{value: value, payment_method: payment_method})
       when is_number(value) do
    case payment_method do
      "P" -> value * @pix_fee
      "D" -> value * @debit_fee
      "C" -> value * @credit_fee
      _ -> {:error, Error.build(:bad_request, "invalid payment method")}
    end
  end

  defp calculate_fee(_), do: {:error, Error.build(:bad_request, "value is not a number")}

  defp update_account_balance_multi(multi, %Account{} = account, new_balance) do
    rounded_balance = Float.round(new_balance, 2)
    changeset = Account.changeset(account, %{balance: rounded_balance})
    Ecto.Multi.update(multi, {:account, Ecto.UUID.generate()}, changeset)
  end

  defp insert_transaction_multi(multi \\ Ecto.Multi.new(), params) do
    changeset = Transaction.changeset(params)
    Ecto.Multi.insert(multi, {:transaction, Ecto.UUID.generate()}, changeset)
  end

  defp handle_create_transaction_response({:ok, response}) do
    {:ok,
     Map.values(response)
     |> List.first()}
  end

  defp handle_create_transaction_response({:error, _, changeset_error, _}) do
    {:error, Error.build(:bad_request, changeset_error)}
  end
end
