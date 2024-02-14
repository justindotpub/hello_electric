# lib/my_app/proxy_repo.ex
defmodule HelloElectric.ProxyRepo do
  use Ecto.Repo,
    otp_app: :hello_electric,
    adapter: Ecto.Adapters.Postgres
end
