defmodule ObjectiveChallenge.Bank.Account do
  use ObjectiveChallenge.Schema

  alias ObjectiveChallenge.Bank.Transaction

  @fields [:account_number, :balance]
  @required_fields [:account_number, :balance]

  @derive {Jason.Encoder, only: @fields}

  schema "accounts" do
    field :account_number, :integer
    field :balance, :float

    has_many(:transactions, Transaction, foreign_key: :account_id)

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:account_number, name: :unique_account_number_index)
  end
end
