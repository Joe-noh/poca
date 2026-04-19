import Config

config :poca, PocaWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

config :poca, PocaWeb.Endpoint,
  force_ssl: [
    rewrite_on: [:x_forwarded_proto],
    exclude: [
      # paths: ["/health"],
      hosts: ["localhost", "127.0.0.1"]
    ]
  ]

config :logger, level: :info
