defmodule Stuck.Fragment do
  use Stuck.Web, :model

  schema "fragments" do
    field :header, :string
    field :body, :string
    belongs_to :article, Stuck.Article

    timestamps()
  end

  @required_fields ~w(body)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:header, :body, :article_id])
    |> validate_required([:header, :body, :article_id])
  end
end
