defmodule Stuck.Router do
  use Stuck.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Stuck.Plugs.AuthPlug, []
  end

  pipeline :auth do
    plug :accepts, ["json"]
  end

  scope "/view", Stuck do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    scope "/v1", V1, as: :v1 do
      get "/twitter/login", UserController, :index
    end
  end

  scope "/api", Stuck do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/me/articles", ArticleController, except: [:new]
      resources "/me/articles/:article_id/fragments", FragmentController, except: [:new]
      get "/me", UserController, :show
      put "/me", UserController, :update
      patch "/me", UserController, :update
      delete "/me", UserController, :delete
    end
  end

  scope "/auth", Stuck do
    pipe_through :auth

    scope "/v1", V1, as: :v1 do
      get "/twitter/callback", UserController, :callback
    end
  end
end
