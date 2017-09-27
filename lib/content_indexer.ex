defmodule ContentIndexer do
  @moduledoc """
  Documentation for ContentIndexer.
  """
  use Application
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      worker(ContentIndexer.Services.Calculator, []),
      worker(ContentIndexer.Services.ListCheckerServer, []),
      worker(ContentIndexer.Services.ListCheckerWorker, []),
      worker(ContentIndexer.Indexer, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ContentIndexer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
