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
  queues: [default: 10],
  plugins: [
    {Oban.Plugins.Pruner, max_age: 60 * 60 * 24 * 7},
    {Oban.Plugins.Lifeline, rescue_after: :timer.minutes(30)},
    {Oban.Plugins.Cron,
     crontab: [
       {"*/10 * * * *", Poca.RefreshFeedWorker, max_attempts: 1}
     ]}
  ]

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :phoenix_vite, PhoenixVite.Npm,
  assets: [args: [], cd: Path.expand("../assets", __DIR__)],
  vite: [args: ~w(exec -- vite), cd: Path.expand("../assets", __DIR__), env: %{"MIX_BUILD_PATH" => Mix.Project.build_path()}]

import_config "#{config_env()}.exs"
