defmodule Stuck.HeaderUtil do
  use Stuck.Web, :util

  import Plug.Conn
  alias Stuck.Redis

  def get_token(conn) do
    header_value = Enum.find(conn.req_headers, &elem(&1, 0) == "authorization")
                   |> elem(1)
    [_, [token]] = Regex.scan(~r/^Bearer|\w+/, header_value)
    token
  end
end
