defmodule Data.Repo.Migrations.CreateTweets do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :time, :utc_datetime
      add :location, :string
      add :content, :string
      add :hashtags, {:array, :string}
    end
  end
end
