defmodule Stuck.Repo.Migrations.CreateArticle do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

  end
end
