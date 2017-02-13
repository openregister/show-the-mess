defmodule ShowTheMess.Router do
  use ShowTheMess.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ShowTheMess do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/clear", PageController, :clear_cache
  end

  # Other scopes may use custom stacks.
  # scope "/api", ShowTheMess do
  #   pipe_through :api
  # end
end
