use Mix.Config

config :appsignal, :config, revision: "0.01"
  active: true,
  otp_app: :metrics,
  name: "cscs_5280_project",
  push_api_key: "790327eb-fe5a-4613-ae9d-846e340c59b7",
  env: Mix.env
