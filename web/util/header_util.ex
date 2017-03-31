defmodule Stuck.HeaderUtil do
  use Stuck.Web, :util

  import Plug.Conn
  alias Stuck.Redis

  def get_token(conn) do
    header_value = Enum.find(conn.req_headers, &elem(&1, 0) == "authorization")
                   |> elem(1)
    case Regex.scan(~r/^Bearer|[0-9a-zA-Z-_]+/, header_value) do
      [_, [token]] ->
        token
      [_, [pre, pos]] ->
        pre <> "-" <> pos
    end
  end
end
