defmodule ObjectiveChallenge.Bank.Transaction do
  use ObjectiveChallenge.Schema

  alias ObjectiveChallenge.Bank.Account

  @fields [:value, :fee, :account_id]
  @required_fields [:value, :fee, :account_id]

  @derive {Jason.Encoder, only: @fields}

  schema "transactions" do
    field :value, :float
    field :fee, :float

    belongs_to(:account, Account, references: :id, type: :binary_id)

    timestamps()
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required_fields)
  end
end
