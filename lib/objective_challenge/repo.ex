defmodule ObjectiveChallenge.Repo do
  use Ecto.Repo,
    otp_app: :objective_challenge,
    adapter: Ecto.Adapters.Postgres
end
