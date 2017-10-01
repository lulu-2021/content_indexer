defmodule ContentIndexer.Store.InMemoryAdapter do
  @moduledoc """
    in memory storeage adapter for the Corpus Genserver
  """

  def init(args), do: {:ok, args}
  def reset(args), do: {:ok, args}

  def put(_key, value), do: {:ok, value}

  def get_value(key), do: {:ok, key}
end
