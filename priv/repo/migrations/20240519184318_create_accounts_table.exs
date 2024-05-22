defmodule ObjectiveChallenge.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :account_number, :integer, null: false
      add :balance, :float, null: false

      timestamps()
    end

    create unique_index(:accounts, :account_number, name: :unique_account_number_index)
  end
end
