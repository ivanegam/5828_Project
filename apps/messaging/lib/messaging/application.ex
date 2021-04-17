defmodule Messaging.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the PubSub system
      {Phoenix.PubSub, name: Messaging.PubSub}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Messaging.Supervisor)
  end
end
