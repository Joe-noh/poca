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

  pipeline :require_login do
    plug PocaWeb.RequireLoginPlug
  end

  scope "/", PocaWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/manifest.json", PageController, :manifest
  end

  scope "/", PocaWeb do
    pipe_through [:browser, :require_login]

    get "/listen", ListenController, :index
    get "/library", LibraryController, :index
    get "/queue", QueueController, :index
    get "/search", SearchController, :index

    resources "/episodes", EpisodeController, only: [] do
      resources "/playback", PlaybackController, only: [:update], singleton: true
    end
  end

  scope "/auth", PocaWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  if Application.compile_env(:poca, :dev_routes) do
    scope "/", PocaWeb do
      get "/.well-known/appspecific/com.chrome.devtools.json", PageController, :chrome_devtools
    end
  end
end
