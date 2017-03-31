defmodule Stuck.Redis do
  alias Stuck.User
  alias Stuck.HeaderUtil

  def get_user_id(conn) do
    token = conn |> HeaderUtil.get_token
    {:ok, id} = get_connection()
                |> Redix.command(~w(GET #{token}))
    id
  end

  def get_user(conn) do
    id = conn |> get_user_id
    if id, do: Stuck.Repo.get(User, id) |> Stuck.Repo.preload(:articles)
  end

  def delete_user_id(conn) do
    token = conn |> HeaderUtil.get_token
    get_connection
    |> Redix.command(~w(DEL #{token}))
  end

  def save_user_id(user_id, token) do
    get_connection()
    |> Redix.command(~w(SET #{token} #{user_id}))
  end

  defp get_connection do
    case caseSystem.get_env("REDIS_URL") do
      nil ->
        {:ok, conn} = Redix.start_link()
        conn
      url ->
        {:ok, conn} = Redix.start_link(url)
        conn
    end

    {:ok, conn} = Redix.start_link()
    conn
  end
end
