# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :stuck,
  ecto_repos: [Stuck.Repo]

# Configures the endpoint
config :stuck, Stuck.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bH3uAE42+isT+RBNMypS/S9Tcal2FKhZjVVYTPYsy2GNFpWDgJ0abr+geC61+JFI",
  render_errors: [view: Stuck.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Stuck.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :extwitter, :oauth, [
  consumer_key: System.get_env("CONSUMER_KEY"),
  consumer_secret: System.get_env("CONSUMER_SECRET") ,
  access_token: System.get_env("ACCESS_TOKEN") ,
  access_token_secret: System.get_env("ACCESS_TOKEN_SECRET")
]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
