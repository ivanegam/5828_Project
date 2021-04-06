ExUnit.start()

Mox.defmock(CovidCases.CDCAPI.MockClient, for: CovidCases.CDCAPI)

Application.put_env(:covid_cases, :cdc_api, CovidCases.CDCAPI.MockClient)