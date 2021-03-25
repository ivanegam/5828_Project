defmodule CovidTweetsWeb.PageLive do
  use CovidTweetsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    IO.inspect(connected?(socket), label: "CONNTECTION STATUS")
    {:ok, socket}
  end

  @impl true
  def handle_event("next", _, socket) do
    {:noreply, socket |> push_event("points", %{points: get_points()})}
  end

  @impl true
  def handle_event("start_date", %{"params" => params}, socket) do
    IO.puts(params)
  end

  defp get_points, do: 1..7 |> Enum.map(fn _ -> :rand.uniform(100) end)

end