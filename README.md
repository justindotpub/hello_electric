# HelloElectric

## Pre-reqs

Their [pre-reqs](https://github.com/electric-sql/electric/tree/main/components/electric#pre-reqs) section currently lists Elixir 1.15 and Erlang/OTP 25, but their [.tool-versions](https://github.com/electric-sql/electric/blob/main/.tool-versions) is different, so I'm going with that.

```
cat <<EOF > .tool-versions
elixir 1.16.1-otp-25
erlang 25.3.2.8
EOF
asdf install
```
## Create Phoenix project
```
mix archive.install hex phx_new
mix phx.new hello_electric --no-live --no-tailwind --no-html
cd hello_electric
cp ../.tool-versions .
git init
git add .
git commit -m "Initial project"
```

Make sure we use 

Add `:electric` as a dependency.
```
{:electric, github: "electric-sql/electric", sparse: "components/electric", branch: "main"},
```
Update deps
```
mix deps.get
git add .
git ci -m "Add electric as a dependency"
```

Append runtime.exs from electric to our config, with extra import removed.

Add `dotenvy` to our deps, since it is used in electric's runtime config.
```
{:dotenvy, "~> 0.8.0"}
```
Copy .env.dev over, but update port from 54321 to 5432 and host to just localhost instead of host.docker.internal.

Follow steps at https://electric-sql.com/docs/usage/installation/postgres#homebrew to set up Postgres.

```
psql -U postgres -c 'ALTER SYSTEM SET wal_level = logical'
brew services restart postgresql
```

Set up database user permissions per https://electric-sql.com/docs/api/service#database-user-permissions.
I'm going to start with just LOGIN and SUPERUSER.

```
psql -U postgres -c "DROP ROLE electric"
psql -U postgres -c "CREATE ROLE electric WITH LOGIN PASSWORD 'electric' SUPERUSER"
```

Make the changes for proxy repo per https://electric-sql.com/docs/integrations/backend/phoenix#proxy-repo.

Try setting up the project.
```
$mix setup
Resolving Hex dependencies...
Resolution completed in 0.173s
Unchanged:
  backoff 1.1.6
  bandit 1.2.1
  castore 1.0.5
  db_connection 2.6.0
  decimal 2.1.1
  dns_cluster 0.1.3
  dotenvy 0.8.0
  ecto 3.11.1
  ecto_sql 3.11.1
  elixir_make 0.7.8
  epgsql 4.7.1
  esbuild 0.8.1
  ets 0.9.0
  expo 0.5.1
  finch 0.18.0
  gen_stage 1.2.1
  gettext 0.24.0
  gproc 0.9.1
  hpax 0.1.2
  jason 1.4.1
  joken 2.6.0
  jose 1.11.6
  libgraph 0.16.0
  mime 2.0.5
  mint 1.5.2
  mint_web_socket 1.0.3
  mox 1.1.0
  nimble_options 1.1.0
  nimble_parsec 1.4.0
  nimble_pool 1.0.0
  pathex 2.5.2
  phoenix 1.7.11
  phoenix_ecto 4.4.3
  phoenix_html 4.0.0
  phoenix_live_dashboard 0.8.3
  phoenix_live_view 0.20.6
  phoenix_pubsub 2.1.3
  phoenix_template 1.0.4
  plug 1.15.3
  plug_crypto 2.0.0
  postgrex 0.17.4
  protox 1.7.3
  req 0.4.8
  ssl_verify_fun 1.1.7
  swoosh 1.15.2
  telemetry 1.2.1
  telemetry_metrics 0.6.2
  telemetry_poller 1.0.0
  thousand_island 1.3.2
  websock 0.5.3
  websock_adapter 0.5.5
All dependencies are up to date
Compiling 11 files (.ex)
Generated hello_electric app

14:04:20.623 [error] Postgrex.Protocol (#PID<0.542.0>) failed to connect: ** (DBConnection.ConnectionError) tcp connect (localhost:65432): connection refused - :econnrefused

14:04:20.626 [error] Postgrex.Protocol (#PID<0.546.0>) failed to connect: ** (DBConnection.ConnectionError) tcp connect (localhost:65432): connection refused - :econnrefused
** (Mix) The database for HelloElectric.ProxyRepo couldn't be created: killed
```

Fails on ecto.create because it's trying to connect to the proxy repo that hasn't started yet.

This confirms that this isn't supposed to run in the same BEAM.  It must be a separate BEAM running, so that this one can rely on the other as it's postgres connection.

There may also be some issues with env vars not being picked up by dotenvy in mix tasks.  Need to confirm.

