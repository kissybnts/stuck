defmodule Stuck.ArticleView do
  use Stuck.Web, :view

  def render("index.json", %{articles: articles}) do
    %{data: render_many(articles, Stuck.ArticleView, "article.json")}
  end

  def render("show.json", %{article: article}) do
    %{data: render_one(article, Stuck.ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
    %{id: article.id,
      title: article.title,
      fragments: render_many(article.fragments, Stuck.FragmentView, "fragment.json")}
  end
end
