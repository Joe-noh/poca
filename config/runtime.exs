import Config

if System.get_env("PHX_SERVER") do
  config :poca, PocaWeb.Endpoint, server: true
end

config :poca, PocaWeb.Endpoint, http: [port: String.to_integer(System.get_env("PORT", "4000"))]

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
    url: [host: System.get_env("PHX_HOST", "example.com"), port: 443, scheme: "https"],
    http: [ip: {0, 0, 0, 0, 0, 0, 0, 0}],
    secret_key_base: System.fetch_env!("SECRET_KEY_BASE")
end
