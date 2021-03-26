# TwitterTest

# Ubuntu installation
wget https://packages.erlang-solutions.com
wget erlang-solutions_2.0_all.deb && sudo dpkg -i erlang-solutions_2.0_all.deb
sudo apt-get install esl-erlang
sudo apt-get install elixir


# Starting a new project
mix new <name of project>
# Add hex package manager
mix local.hex
# add extwitter
once added to the mix.exs
mix deps.get

# run program
mix compile
mix run


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `twitter_test` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:twitter_test, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/twitter_test](https://hexdocs.pm/twitter_test).
