defmodule HelloElectric.Repo do
  use Ecto.Repo,
    otp_app: :hello_electric,
    adapter: Ecto.Adapters.Postgres
end
