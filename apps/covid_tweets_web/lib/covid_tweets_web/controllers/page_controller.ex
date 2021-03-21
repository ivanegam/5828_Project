defmodule CovidTweetsWeb.PageController do
  use CovidTweetsWeb, :controller

  def index(conn, _params) do
    tweets = Data.Tweet |> Data.Repo.all
    render(conn, "index.html", tweets: tweets)
  end
end
