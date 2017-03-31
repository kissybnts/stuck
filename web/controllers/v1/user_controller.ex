defmodule Stuck.V1.UserController do
  use Stuck.Web, :controller

  import Ecto.Changeset, only: [put_change: 3]

  alias Stuck.User
  alias Stuck.Redis

  # Redirect to twitter authentication page
  def index(conn, _params) do
    token = ExTwitter.request_token(get_domain() <> "/auth/v1/twitter/callback")
    {:ok, authenticate_url} = ExTwitter.authenticate_url(token.oauth_token)
    redirect conn, external: authenticate_url
  end

  def callback(conn, %{"oauth_token" => oauth_token, "oauth_verifier" => oauth_verifier}) do
    {:ok, access_token} = ExTwitter.access_token(oauth_verifier, oauth_token)

    ExTwitter.configure(
      :process,
      Enum.concat(
        ExTwitter.Config.get_tuples,
        [access_token: access_token.oauth_token, access_token_secret: access_token.oauth_token_secret]
      )
    )

    user_info = ExTwitter.verify_credentials()
    changeset = User.changeset(%User{}, %{name: user_info.screen_name, sns: 1})

    query = from u in User,
      where: u.name == ^user_info.screen_name,
      select: u

    case Repo.one(query) do
      nil ->
        case Repo.insert(changeset) do
          {:ok, user} ->
            Redis.save_user_id(user.id, access_token.oauth_token)
            conn
            |> put_status(:ok)
            |> render("twitter_login.json", user: user, token: access_token.oauth_token)
          {:error, _} ->
            conn
            |> put_status(:internal_server_error)
            |> render(Stuck.ErrorView, "error_message.json", message: "DB error occurred")
        end
      exist ->
        conn
        |> put_status(:ok)
        |> render("twitter_login.json", user: exist, token: access_token.oauth_token)
    end
  end

  def show(conn, _params) do
    user = conn
           |> Redis.get_user
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"user" => user_params}) do
    changeset = conn
                |> Redis.get_user
                |> User.changeset(user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Stuck.ChangesetView, "error.json", changeset: changeset)
    end
  end

  # def logout(conn, _params) do
  #   conn
  #   |> put_status(:ok)
  #
  #   send_resp(conn, :no_content, "")
  # end

  def delete(conn, _params) do
    user = conn |> Redis.get_user

    conn |> Redis.delete_user_id

    Repo.delete!(user)

    conn
    |> put_status(:ok)
    |> send_resp(:no_content, "")
  end

  defp get_domain() do
    System.get_env("DOMAIN") || "http://localhost:4000"
  end
end
