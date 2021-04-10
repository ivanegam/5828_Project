defmodule Data.Repo.Migrations.CreateHashtags do
  use Ecto.Migration

  def change do
    create table(:hashtags) do
      add :date, :date
      add :hashtags, {:array, :string}
      add :label, :string
    end
  end
end
