defmodule Stuck.User do
  use Stuck.Web, :model

  schema "users" do
    field :name, :string
    field :sns, :integer
    has_many :articles, Stuck.Article

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :sns])
    |> unique_constraint(:name)
  end
end
