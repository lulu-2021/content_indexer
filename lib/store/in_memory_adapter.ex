defmodule ContentIndexer.Store.InMemoryAdapter do
  @moduledoc """
    in memory storeage adapter for the Corpus Genserver
  """

  def init(args), do: args
  def reset(args), do: args

  def put(_key, value), do: value

  def get_value(key), do: key
end
