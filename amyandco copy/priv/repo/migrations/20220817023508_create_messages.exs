defmodule Amyandco.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :name, :string
      add :body, :string

      timestamps()
    end
  end
end
