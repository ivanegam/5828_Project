defmodule DataAnalysis do
  @moduledoc """
  Data analysis of tweets.
  """

  @doc """
  Get the sentitment of text.
  """
  def get_sentiment(text) do
    Veritaserum.analyze(text)
  end
end
