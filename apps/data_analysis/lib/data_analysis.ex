defmodule DataAnalysis do
  @moduledoc """
  Function for performing sentiment analysis
  """

  @doc """
  Get the sentiment of text using the AFINN-165 (list of English words rated for valence)
  """
  def get_sentiment(text) do
    Veritaserum.analyze(text)
  end
end
