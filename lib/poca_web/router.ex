defmodule PocaWeb.Router do
  use PocaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PocaWeb.Layouts, :root}
    plug :protect_from_forgery
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
  end

  scope "/", PocaWeb do
    pipe_through [:browser, :require_login]

    get "/listen", ListenController, :index
    get "/library", LibraryController, :index
    get "/queue", QueueController, :index
    get "/search", SearchController, :index
  end

  scope "/auth", PocaWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:poca, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/", PocaWeb do
      get "/.well-known/appspecific/com.chrome.devtools.json", PageController, :chrome_devtools
    end

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PocaWeb.Telemetry
    end
  end
end
