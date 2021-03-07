defmodule CovidTweetsWeb.PageController do
  use CovidTweetsWeb, :controller

  def index(conn, params) do
    name = params["name"] || "World"
    render(conn, "index.html", name: name)
  end
end
