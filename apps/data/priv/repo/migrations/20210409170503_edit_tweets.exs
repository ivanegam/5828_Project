defmodule Data.Repo.Migrations.EditTweets do
  use Ecto.Migration

  def change do
    alter table(:tweets) do
      add :label, :string
    end
  end
end
