defmodule ObjectiveChallengeWeb.Plugs.ParseRequestsInputTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias ObjectiveChallengeWeb.Plugs.ParseRequestsInput

  @opts ParseRequestsInput.init([])

  test "parses params and filters out nil values" do
    conn =
      conn(:get, "/", %{
        "numero_conta" => "12345",
        "forma_pagamento" => "credit_card",
        "valor" => "100.0",
        "saldo" => nil
      })

    conn = ParseRequestsInput.call(conn, @opts)

    expected_params = %{
      account_number: "12345",
      payment_method: "credit_card",
      value: "100.0"
    }

    assert conn.params == expected_params
  end

  test "parses params and retains all non-nil values" do
    conn =
      conn(:get, "/", %{
        "numero_conta" => "67890",
        "forma_pagamento" => "debit_card",
        "valor" => "200.0",
        "saldo" => "300.0"
      })

    conn = ParseRequestsInput.call(conn, @opts)

    expected_params = %{
      account_number: "67890",
      payment_method: "debit_card",
      value: "200.0",
      balance: "300.0"
    }

    assert conn.params == expected_params
  end

  test "parses params and handles empty input gracefully" do
    conn = conn(:get, "/", %{})

    conn = ParseRequestsInput.call(conn, @opts)

    expected_params = %{}

    assert conn.params == expected_params
  end

  test "parses params and handles partial input" do
    conn =
      conn(:get, "/", %{
        "numero_conta" => "54321"
      })

    conn = ParseRequestsInput.call(conn, @opts)

    expected_params = %{
      account_number: "54321"
    }

    assert conn.params == expected_params
  end
end
