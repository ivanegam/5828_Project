use Mix.Config

import_config "appsignal.exs"


config :my_app, MyAppWeb.Endpoint,
  live_view: [signing_salt: "SECRET_SALT"]
