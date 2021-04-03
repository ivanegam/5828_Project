defmodule CovidTweetsWeb.PageLive do
  use CovidTweetsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("change_date", %{"start_date" => sd, "end_date"=>ed}, socket) do
    # IO.puts("Called with 1: #{inspect sd} #{inspect ed}")
    {:noreply, socket |> push_event("dates", %{start_date: sd, end_date: ed})}
  end

end