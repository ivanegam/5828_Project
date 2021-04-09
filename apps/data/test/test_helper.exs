Application.load(:data)
Application.ensure_all_started(:data)
for app <- Application.spec(:data, :applications) do
  Application.ensure_all_started(app)
end

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Data.Repo, :manual)