defmodule CovidTweetsWeb.TweetDisplayView do
  use CovidTweetsWeb, :view
  use Timex
  
  Application.ensure_all_started :timex
  @tz Timezone.get("America/Denver", Timex.now())
  
  # Format datetime for the tweet display
  def format_datetime(d) do
    {:ok, formatted} =
      Timezone.convert(d, @tz)
      |> Timex.format("{Mshort} {D}, {YYYY}  {h12}:{m} {am}")
    
    formatted
  end

end