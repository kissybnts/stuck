defmodule Stuck.V1.ArticleView do
  use Stuck.Web, :view

  def render("index.json", %{articles: articles}) do
    %{articles: render_many(articles, Stuck.V1.ArticleView, "article.json")}
  end

  def render("show.json", %{article: article}) do
    %{articles: render_one(article, Stuck.V1.ArticleView, "article.json")}
  end

  def render("article.json", %{article: article}) do
    case Stuck.EctoUtils.is_preloaded(article, :fragments) do
      true -> %{id: article.id,
                title: article.title,
                fragments: render_many(article.fragments, Stuck.V1.FragmentView, "fragment.json")}
      _ -> %{id: article.id,
            title: article.title}
    end
  end
end
