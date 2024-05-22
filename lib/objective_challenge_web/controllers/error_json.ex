defmodule ObjectiveChallengeWeb.ErrorJSON do
  import Ecto.Changeset, only: [traverse_errors: 2]

  alias Ecto.Changeset

  def error(%{result: %Changeset{} = changeset}) do
    %{mesage: translate_errors(changeset)}
  end

  def error(%{result: result}) do
    %{message: result}
  end

  def translate_errors(changeset) do
    traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", translate_value(value))
      end)
    end)
  end

  defp translate_value(value), do: to_string(value)
end
