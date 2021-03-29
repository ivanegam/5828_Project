defmodule CovidTweetsWeb.PageController do
  use CovidTweetsWeb, :controller
  import Ecto.Query, only: [from: 2]

  @tweet_display_query from Data.Tweet, order_by: [desc: :time, desc: :retweet_count], limit: 5

  def index(conn, _params) do
    tweets =
      @tweet_display_query
      |> Data.Repo.all
    render(conn, "index.html", tweets: tweets)
  end
end
