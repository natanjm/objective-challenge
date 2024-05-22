defmodule ObjectiveChallengeWeb.Plugs.ParseRequestsInput do
  def init(opts), do: opts

  def call(%{params: params} = conn, _) do
    parsed_params =
      %{
        account_number: params["numero_conta"],
        payment_method: params["forma_pagamento"],
        value: params["valor"],
        balance: params["saldo"]
      }
      |> Enum.filter(fn {_, v} -> !is_nil(v) and v != "" end)
      |> Enum.into(%{})

    Map.put(conn, :params, parsed_params)
  end
end
