defmodule CovidTweetsWeb.Router do
  use CovidTweetsWeb, :router
  import Phoenix.LiveDashboard.Router
  import Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    # plug :fetch_flash
    plug :fetch_live_flash
    plug :put_root_layout, {CovidTweetsWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CovidTweetsWeb do
    pipe_through :browser

    #get "/", PageController, :index
    live "/", TweetsLive, :index
  end

  scope "/graphs", CovidTweetsWeb do
    pipe_through :browser

    # get "/", PageController, :index
    live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", CovidTweetsWeb do
  #   pipe_through :api
  # end

  pipeline :admins_only do
    plug :basic_auth, username: "admin", password: "Hippity Hoppity"
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  #if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:browser, :admins_only]
      live_dashboard "/dashboard", metrics: CovidTweetsWeb.Telemetry
    end
  #end
end
