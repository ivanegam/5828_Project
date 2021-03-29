defmodule CovidTweetsWeb.PageController do
  use CovidTweetsWeb, :controller
  import Ecto.Query, only: [from: 2]

  @query from Data.Tweet, order_by: [desc: :time, desc: :retweet_count]
  def index(conn, _params) do
    tweets =
      @query
      |> Data.Repo.all
    render(conn, "index.html", tweets: tweets)
  end
end
