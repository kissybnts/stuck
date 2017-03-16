defmodule Stuck.V1.ArticleController do
  use Stuck.Web, :controller

  alias Stuck.Article
  alias Stuck.Redis

  def index(conn, _params) do
    id = conn |> Redis.get_user_id
    query = from a in Article,
      where: a.user_id == ^id,
      select: a
    articles = query |> Repo.all |> Repo.preload(:fragments)
    render(conn, "index.json", articles: articles)
  end

  def create(conn, %{"article" => article_params}) do
    id = conn |> Redis.get_user_id
    changeset = Article.changeset(%Article{}, Map.put(article_params, :user_id, id))

    case Repo.insert(changeset) do
      {:ok, article} ->
        conn
        |> put_status(:created)
        |> render("show.json", article: article)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Stuck.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    article = Repo.get!(Article, id) |> Repo.preload(:fragments)
    user_id = conn |> Redis.get_user_id
    if article.user.id == user_id do
      conn
      |> put_status(:ok)
      |> render("show.json", article: article)
    else
      conn
      |> put_status(:bad_request)
      |> render(Stuck.ErrorView, "error_message.json", message: "not accepted")
    end
  end

  def update(conn, %{"id" => id, "article" => article_params}) do

    case get_users_article(conn, id) do
      {:ok, article} ->
          conn
          |> update!(article, article_params)
      {:error, _} ->
        conn
        |> put_status(:bad_request)
        |> render(Stuck.ErrorView, "error_message.json", message: "not accepted")
    end
  end

  defp update!(conn, article, article_params) do
    changeset = Article.changeset(article, article_params)

    case Repo.update(changeset) do
      {:ok, article} ->
        render(conn, "show.json", article: article)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Stuck.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_id = conn |> Session.current_user_id
    article = Repo.get!(Article, id)

    case get_users_article(conn, id) do
      {:ok, article} ->
        Repo.delete!(article)
        conn
        |> send_resp(:ok, "")
      {:error, _} ->
        conn
        |> put_status(:bad_request)
        |> render(Stuck.ErrorView, "error_message.json", message: "not accepted")
    end
  end

  defp get_users_article(conn, article_id) do
    user_id = conn |> Redis.get_user_id
    Repo.get_by(Article, id: article_id, user_id: user_id) |> Repo.preload(:fragments)
  end
end
