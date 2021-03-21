defmodule Data.Tweet do
  use Ecto.Schema

  schema "tweets" do
    field :time, :utc_datetime
    field :location, :string
    field :content, :string
    field :hashtags, {:array, :string}
  end

  def changeset(tweet, params \\ %{}) do
    tweet
    |> Ecto.Changeset.cast(params, [:time, :location, :content, :hashtags])
    |> Ecto.Changeset.validate_required([:time, :location, :content, :hashtags])
  end
end