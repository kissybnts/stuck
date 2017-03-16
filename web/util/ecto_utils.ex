defmodule Stuck.EctoUtils do
  use Stuck.Web, :util

  def is_preloaded(model, assoc) do
    case Map.get(model, assoc) do
      %Ecto.Association.NotLoaded{} -> false
      _ -> true
    end
  end
end
