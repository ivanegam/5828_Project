defmodule Data.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Data.Repo

      import Ecto
      import Ecto.Query
      import Data.RepoCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Data.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Data.Repo, {:shared, self()})
    end

    :ok
  end
end