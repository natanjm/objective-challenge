defmodule ObjectiveChallengeWeb.AccountJSON do
  alias ObjectiveChallenge.Bank.Account

  def show(%{account: %Account{} = account}) do
    %{
      numero_conta: account.account_number,
      saldo: account.balance
    }
  end
end
