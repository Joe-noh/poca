import Config

config :poca, Poca.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "poca_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

config :poca, PocaWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "CNbLNWsU40xXd6rLqraAUqCLCqJ8auCwI/JqMVN90N76Dsj/nbmnRNbpqY7r4RDd",
  watchers: [vite: {PhoenixVite.Npm, :run, [:vite, ~w(dev)]}],
  server: false

config :poca, Oban, testing: :manual

config :poca, :feed_req_opts, plug: {Req.Test, Poca.Podcasts.FeedTestPlug}, retry: false
config :poca, :itunes_req_opts, plug: {Req.Test, Poca.Podcasts.ItunesTestPlug}, retry: false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime
config :phoenix, sort_verified_routes_query_params: true

config :mix_test_watch, tasks: ["test", "credo"]
