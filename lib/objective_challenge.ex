defmodule ObjectiveChallenge do
  @moduledoc """
  ObjectiveChallenge keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias ObjectiveChallenge.Bank

  defdelegate create_account(params), to: Bank, as: :create_account
  defdelegate get_account_by_number(account_number), to: Bank, as: :get_account_by_number
  defdelegate create_transaction(params), to: Bank, as: :create_transaction
end
