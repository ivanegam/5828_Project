Application.load(:covid_cases)

for app <- Application.spec(:covid_cases, :applications) do
  Application.ensure_all_started(app)
end

ExUnit.start()

Mox.defmock(CovidCases.CDCAPI.MockClient, for: CovidCases.CDCAPI)

Application.put_env(:covid_cases, :cdc_api, CovidCases.CDCAPI.MockClient)