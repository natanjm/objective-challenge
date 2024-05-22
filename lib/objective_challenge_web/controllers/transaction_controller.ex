defmodule ObjectiveChallengeWeb.TransactionController do
  use ObjectiveChallengeWeb, :controller

  plug(ObjectiveChallengeWeb.Plugs.ParseRequestsInput)

  action_fallback ObjectiveChallengeWeb.FallbackController

  def create(conn, params) do
    with {:ok, account} <- ObjectiveChallenge.create_transaction(params) do
      put_status(conn, :created)
      |> put_view(json: ObjectiveChallengeWeb.AccountJSON)
      |> render(:show, account: account)
    end
  end
end
