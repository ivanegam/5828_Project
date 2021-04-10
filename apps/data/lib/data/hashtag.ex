defmodule Data.Hashtag do
  use Ecto.Schema

  schema "hashtags" do
    field :date, :date
    field :hashtags, {:array, :string}
    field :label, Ecto.Enum, values: [:covid_tweets, :vaccine_tweets]
  end

  def changeset(hashtag, params \\ %{}) do
    hashtag
    |> Ecto.Changeset.cast(params, [:date, :hashtags, :label])
    |> Ecto.Changeset.validate_required([:date, :hashtags, :label])
    |> Ecto.Changeset.validate_inclusion(:label, [:covid_tweets, :vaccine_tweets])
  end
end