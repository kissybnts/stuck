defmodule Stuck.FragmentController do
  use Stuck.Web, :controller

  alias Stuck.Fragment

  def index(conn, _params) do
    fragments = Repo.all(Fragment)
    render(conn, "index.json", fragments: fragments)
  end

  def create(conn, %{"fragment" => fragment_params}) do
    changeset = Fragment.changeset(%Fragment{}, fragment_params)

    case Repo.insert(changeset) do
      {:ok, fragment} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", fragment_path(conn, :show, fragment))
        |> render("show.json", fragment: fragment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Stuck.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    fragment = Repo.get!(Fragment, id)
    render(conn, "show.json", fragment: fragment)
  end

  def update(conn, %{"id" => id, "fragment" => fragment_params}) do
    fragment = Repo.get!(Fragment, id)
    changeset = Fragment.changeset(fragment, fragment_params)

    case Repo.update(changeset) do
      {:ok, fragment} ->
        render(conn, "show.json", fragment: fragment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Stuck.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    fragment = Repo.get!(Fragment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(fragment)

    send_resp(conn, :no_content, "")
  end
end
