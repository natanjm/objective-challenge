defmodule ObjectiveChallenge.Schema do
  @moduledoc """
  Macro for defining our Domain schemas/entities
  """

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      alias Ecto.Changeset

      @type t :: %__MODULE__{}

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
    end
  end
end
