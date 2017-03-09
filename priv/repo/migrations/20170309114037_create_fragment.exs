defmodule Stuck.Repo.Migrations.CreateFragment do
  use Ecto.Migration

  def change do
    create table(:fragments) do
      add :header, :string
      add :body, :text
      add :article_id, references(:articles, on_delete: :nothing)

      timestamps()
    end
    create index(:fragments, [:article_id])

  end
end
