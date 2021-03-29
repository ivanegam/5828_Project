defmodule Data.Repo.Migrations.CreateDailyCounts do
  use Ecto.Migration

  def change do
    create table(:daily_counts) do
      add :date, :date
      add :label, :string
      add :count, :integer
    end

    create unique_index(:daily_counts, [:date, :label], name: :date_and_label)
  end
end
