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

```

Run `mix setup`.
```

```