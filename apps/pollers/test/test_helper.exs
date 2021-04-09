Application.load(:pollers)

for app <- Application.spec(:pollers, :applications) do
  Application.ensure_all_started(app)
end

ExUnit.start()
