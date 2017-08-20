defmodule ContentIndexer.Mixfile do
  use Mix.Project

  def project do
    [app: :content_indexer,
     version: "0.1.0",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    #[extra_applications: [:logger, :tfidf]]
    # proper supervised application
    [
      mod: {ContentIndexer, []},
      applications: application_list(Mix.env),
      env: [app_env: Mix.env]
    ]
  end

  # the application list functions are so that we can start hound in test ONLY!
  def application_list do
    [
       :logger, :tfidf
    ]
  end

  # when we add HOUND this will come in handy!!
  #def application_list(:test), do: [:hound | application_list]
  def application_list(_),     do: application_list()

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:tfidf, "~> 0.1.2"}
    ]
  end
end
