ExUnit.start()

Mox.defmock(CovidVaccines.CSVReader.MockReader, for: CovidVaccines.CSVReader)

Application.put_env(:covid_vaccines, :csv_reader, CovidVaccines.CSVReader.MockReader)