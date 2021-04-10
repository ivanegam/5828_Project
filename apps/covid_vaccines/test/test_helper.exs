Application.load(:covid_vaccines)

for app <- Application.spec(:covid_vaccines, :applications) do
  Application.ensure_all_started(app)
end

ExUnit.start()

Mox.defmock(CovidVaccines.CSVReader.MockReader, for: CovidVaccines.CSVReader)

Application.put_env(:covid_vaccines, :csv_reader, CovidVaccines.CSVReader.MockReader)