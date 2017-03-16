defmodule Stuck.Article do
  use Stuck.Web, :model

  schema "articles" do
    field :title, :string
    belongs_to :user, Stuck.User
    has_many :fragments, Stuck.Fragment

    timestamps()
  end

  @required_fields ~w(title)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :user_id])
    |> validate_required([:title, :user_id])
  end
end
