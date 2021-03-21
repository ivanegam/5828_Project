defmodule Pollers.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Pollers.Worker.start_link(arg)
      # {Pollers.Worker, arg}
      Pollers.TweetPoller
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pollers.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
