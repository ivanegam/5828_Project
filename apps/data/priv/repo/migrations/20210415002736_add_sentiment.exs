defmodule Data.Repo.Migrations.AddSentiment do
  use Ecto.Migration

  def change do
    alter table(:tweets) do
      add :sentiment, :integer, default: 0
    end
  end
end
