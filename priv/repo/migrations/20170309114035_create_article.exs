defmodule Stuck.Repo.Migrations.CreateArticle do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string

      timestamps()
    end

  end
end
