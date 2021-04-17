defmodule Data.Tweet do
  use Ecto.Schema

  schema "tweets" do
    field :time, :utc_datetime
    field :name, :string
    field :screen_name, :string
    field :profile_image_url, :string
    field :text, :string
    field :hashtags, {:array, :string}
    field :retweet_count, :integer
    field :label, Ecto.Enum, values: [:covid_tweets, :vaccine_tweets]
    field :sentiment, :integer
  end

  @doc """
  Defines a changeset for inserting tweet data into the database,
  conforming to pre-set validation restrictions
  """
  def changeset(tweet, params \\ %{}) do
    tweet
    |> Ecto.Changeset.cast(params, [:time, :name, :screen_name, :profile_image_url, :text, :hashtags, :retweet_count, :label, :sentiment])
    |> Ecto.Changeset.validate_required([:time, :name, :screen_name, :profile_image_url, :text, :hashtags, :retweet_count, :label, :sentiment])
    |> Ecto.Changeset.validate_inclusion(:label, [:covid_tweets, :vaccine_tweets])
  end
end