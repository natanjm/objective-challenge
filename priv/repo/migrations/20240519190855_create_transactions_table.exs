defmodule ObjectiveChallenge.Repo.Migrations.CreateTransactionsTable do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :value, :float, null: false
      add :fee, :float, null: false
      add :account_id, references(:accounts, type: :binary_id), null: false

      timestamps()
    end
  end
end
