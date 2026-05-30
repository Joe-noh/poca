defmodule PocaWeb.Router do
  use PocaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_root_layout, html: {PocaWeb.Layouts, :root}
    plug :put_secure_browser_headers
    plug PocaWeb.CurrentUserPlug
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

  scope "/api", PocaWeb.Api do
    pipe_through [:browser, :require_login]

    resources "/search", SearchController, only: [:create], singleton: true

    resources "/podcasts", PodcastController, only: [:show] do
      resources "/episodes", EpisodeController, only: [:index]
      resources "/subscription", SubscriptionController, only: [:create, :delete], singleton: true
    end

    resources "/episodes", EpisodeController, only: [:index] do
      resources "/playback", PlaybackController, only: [:update], singleton: true
    end

    resources "/queue", QueueController, only: [], singleton: true do
      resources "/episodes", QueueEpisodeController, only: [:index, :create, :delete] do
        put "/move", QueueEpisodeController, :move, on: :collection
      end
    end
  end

  if Application.compile_env(:poca, :dev_routes) do
    scope "/", PocaWeb do
      get "/.well-known/appspecific/com.chrome.devtools.json", PageController, :chrome_devtools
    end
  end

  scope "/", PocaWeb do
    pipe_through [:browser, :require_login]

    get "/*path", PageController, :spa
  end
end
