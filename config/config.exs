import Config

config :poca,
  ecto_repos: [Poca.Repo],
  generators: [timestamp_type: :utc_datetime_usec, binary_id: true]

config :poca, PocaWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: PocaWeb.ErrorHTML, json: PocaWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Poca.PubSub,
  live_view: [signing_salt: "egJFWTJZ"]

config :poca, Oban,
  engine: Oban.Engines.Basic,
  repo: Poca.Repo,
  queues: [default: 10]

  config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

config :esbuild,
  version: "0.25.4",
  poca: [
    args: ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
  ]

config :tailwind,
  version: "4.1.12",
  poca: [
    args: ~w(--input=assets/css/app.css --output=priv/static/assets/css/app.css),
    cd: Path.expand("..", __DIR__)
  ]

config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
