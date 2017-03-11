defmodule Stuck.V1.ArticleView do
  use Stuck.Web, :view

  def render("index.json", %{articles: articles}) do
    %{data: render_many(articles, Stuck.V1.ArticleView, "article.json")}
  end

  def render("show.json", %{article: article}) do
    %{data: render_one(article, Stuck.V1.ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
    %{id: article.id,
      title: article.title,
      fragments: render_many(article.fragments, Stuck.V1.FragmentView, "fragment.json")}
  end
end
