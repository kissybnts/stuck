defmodule Stuck.V1.UserView do
  use Stuck.Web, :view

  # def render("index.json", %{users: users}) do
  #   %{user: render_many(users, Stuck.UserView, "user.json")}
  # end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, Stuck.UserView, "user.json")}
  end

  def render("twitter_login.json", %{user: user, token: token}) do
    %{user: render_one(user, Stuck.UserView, "user.json"),
      token: token}
  end

  def render("user.json", %{user: user}) do
    case Stuck.EctoUtils.is_preloaded(user, :articles) do
      true -> %{id: user.id,
                name: user.name,
                articles: render_many(user.articles, Stuck.V1.ArticleView, "article.json")}
      _ -> %{id: user.id,
            name: user.name}
    end
  end
end
