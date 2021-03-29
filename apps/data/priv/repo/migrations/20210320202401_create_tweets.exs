defmodule Data.Repo.Migrations.CreateTweets do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :time, :utc_datetime
      add :name, :string
      add :screen_name, :string
      add :profile_image_url, :string
      add :text, :string
      add :hashtags, {:array, :string}
      add :retweet_count, :integer
    end
  end
end
