defmodule PocaWeb.Router do
  use PocaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_root_layout, html: {PocaWeb.Layouts, :root}
    plug :put_secure_browser_headers
    plug PocaWeb.CurrentUserPlug
    plug Inertia.Plug
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug PocaWeb.CurrentUserPlug
  end

  pipeline :require_login do
    plug PocaWeb.RequireLoginPlug
  end

  scope "/", PocaWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/auth", PocaWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  scope "/api", PocaWeb do
    pipe_through :browser

    resources "/playback", PlaybackController, only: [:update], singleton: true
  end

  scope "/", PocaWeb do
    pipe_through [:browser, :require_login]

    get "/library", LibraryController, :index
    get "/queue", QueueController, :index

    resources "/search", SearchController, only: [:show, :create], singleton: true

    resources "/podcasts", PodcastController, only: [:show] do
      resources "/subscription", SubscriptionController, only: [:create, :delete], singleton: true
    end

    resources "/episodes", EpisodeController, only: [] do
      resources "/playback", PlaybackController, only: [:update], singleton: true
    end

    get "/*path", PageController, :spa
  end

  if Application.compile_env(:poca, :dev_routes) do
    scope "/", PocaWeb do
      get "/.well-known/appspecific/com.chrome.devtools.json", PageController, :chrome_devtools
    end
  end
end
