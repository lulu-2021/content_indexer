defmodule ContentIndexer.Store.InMemoryAdapter do
  @moduledoc """
    in memory storeage adapter for the Corpus Genserver
  """

  def init(args, _table_name), do: {:ok, args}
  def reset(args, _table_name), do: {:ok, args}

  def put(_key, value, _table_name), do: {:ok, value}

  def get_value(key, _table_name), do: {:ok, key}
end
