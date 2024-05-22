defmodule ObjectiveChallengeWeb.FallbackController do
  use ObjectiveChallengeWeb, :controller

  alias ObjectiveChallenge.Error
  alias ObjectiveChallengeWeb.ErrorJSON

  def call(conn, {:error, %Error{status: status, result: result}}) do
    conn
    |> put_status(status)
    |> put_view(ErrorJSON)
    |> render(:error, result: result)
  end
end
