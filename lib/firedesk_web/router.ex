defmodule FiredeskWeb.Router do
  use FiredeskWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FiredeskWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FiredeskWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/app", FiredeskWeb do
    pipe_through :browser

    live_session :default, on_mount: FiredeskWeb.RouteAssigns do
      live "/", DashboardLive
      live "/dashboard", DashboardLive

      live "/tickets", TicketLive.Index, :index
      live "/tickets/new", TicketLive.Index, :new
      live "/tickets/:id/edit", TicketLive.Index, :edit

      live "/tickets/:id", TicketLive.Show, :show
      live "/tickets/:id/show/edit", TicketLive.Show, :edit

      live "/analytics", AnalyticsLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", FiredeskWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:firedesk, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FiredeskWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
