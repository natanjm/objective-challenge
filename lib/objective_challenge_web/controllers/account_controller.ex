defmodule ObjectiveChallengeWeb.AccountController do
  use ObjectiveChallengeWeb, :controller

  plug(ObjectiveChallengeWeb.Plugs.ParseRequestsInput)

  action_fallback ObjectiveChallengeWeb.FallbackController

  def create(conn, params) do
    with {:ok, account} <- ObjectiveChallenge.create_account(params) do
      put_status(conn, :created)
      |> put_view(json: ObjectiveChallengeWeb.AccountJSON)
      |> render(:show, account: account)
    end
  end

  def show(conn, _params) do
    account_number = Map.get(conn.query_params, "numero_conta")

    with {:ok, account} <- ObjectiveChallenge.get_account_by_number(account_number) do
      put_status(conn, :ok)
      |> put_view(json: ObjectiveChallengeWeb.AccountJSON)
      |> render(:show, account: account)
    end
  end
end
