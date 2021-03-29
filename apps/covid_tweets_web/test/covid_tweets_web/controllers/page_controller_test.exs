defmodule CovidTweetsWeb.PageControllerTest do
  use CovidTweetsWeb.ConnCase
  use CovidTweetsWeb.RepoCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "CovidTweets"
  end
end
