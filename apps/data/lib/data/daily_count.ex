defmodule Data.DailyCount do
  use Ecto.Schema

  schema "daily_counts" do
    field :date, :date
    field :label, Ecto.Enum, values: [:covid_tweets, :vaccine_tweets, :covid_cases, :vaccine_counts]
    field :count, :integer
  end

  def changeset(daily_count, params \\ %{}) do
    daily_count
    |> Ecto.Changeset.cast(params, [:date, :label, :count])
    |> Ecto.Changeset.validate_required([:date, :label, :count])
    |> Ecto.Changeset.validate_number(:count, greater_than_or_equal_to: 0)
    |> Ecto.Changeset.validate_inclusion(:label, [:covid_tweets, :vaccine_tweets, :covid_cases, :vaccine_counts])
    |> Ecto.Changeset.unique_constraint(:date_label_constraint, name: :date_and_label)
  end
end