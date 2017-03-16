defmodule Stuck.Plugs.AuthPlug do
  @behaviour Plug
  import Plug.Conn
  import Phoenix.Controller, only: [render: 4]

  alias Stuck.HeaderUtil
  alias Stuck.Redis

  def init(default), do: default

  # Authorization function for each requests
  def call(conn, _params) do
    case logged_in?(conn) do
      false ->
        IO.puts "Authorization NG"
        conn
        |> put_status(:bad_request)
        |> render(Stuck.ErrorView, "error_message.json", message: "not accepted")
        |> halt
      id ->
        IO.inspect id
        IO.puts "Authorization OK"
        conn
    end
  end

  defp logged_in?(conn), do: !!Redis.get_user_id(conn)
end
