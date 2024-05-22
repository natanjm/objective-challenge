defmodule ObjectiveChallenge.Bank do
  alias ObjectiveChallenge.Bank.Account
  alias ObjectiveChallenge.Error
  alias ObjectiveChallenge.Repo

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
end
