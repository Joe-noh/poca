import Config

if System.get_env("PHX_SERVER") do
  config :poca, PocaWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url = System.fetch_env!("DATABASE_URL")

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :poca, Poca.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  config :poca, :dns_cluster_query, System.get_env("DNS_CLUSTER_QUERY")

  config :poca, PocaWeb.Endpoint,
    url: [host: System.get_env("RENDER_EXTERNAL_HOSTNAME", "localhost"), port: 443, scheme: "https"],
    http: [ip: {0, 0, 0, 0, 0, 0, 0, 0}, port: String.to_integer(System.get_env("PORT", "4000"))],
    secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

  config :ueberauth, Ueberauth.Strategy.Google.OAuth,
    client_id: System.get_env("GOOGLE_CLIENT_ID"),
    client_secret: System.get_env("GOOGLE_CLIENT_SECRET")
end
