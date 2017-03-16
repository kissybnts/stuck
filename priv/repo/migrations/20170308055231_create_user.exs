defmodule Stuck.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :sns, :integer, null: false

      timestamps()
    end

    create unique_index(:users, [:name])
  end
end
