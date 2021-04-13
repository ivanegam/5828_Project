use Mix.Config
import_config "test.exs"

# Here's where the two testing environments differ so that Mox is configured correctly:
config :my_app, service_module: MyApp.TheRealService
