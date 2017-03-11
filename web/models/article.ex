defmodule Stuck.Article do
  use Stuck.Web, :model

  schema "articles" do
    field :title, :string
    has_many :fragments, Stuck.Fragment

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
