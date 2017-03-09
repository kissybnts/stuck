defmodule Stuck.Fragment do
  use Stuck.Web, :model

  schema "fragments" do
    field :header, :string
    field :body, :string
    belongs_to :article, Stuck.Article

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:header, :body])
    |> validate_required([:header, :body])
  end
end
