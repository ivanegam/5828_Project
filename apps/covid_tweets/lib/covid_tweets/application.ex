defmodule CovidTweets.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: CovidTweets.PubSub}
      # Start a worker by calling: CovidTweets.Worker.start_link(arg)
      # {CovidTweets.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: CovidTweets.Supervisor)
  end
end
