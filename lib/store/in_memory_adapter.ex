defmodule ContentIndexer.Store.InMemoryAdapter do
  @moduledoc """
    in memory storeage adapter for the Corpus Genserver
    reall all this is doing is ensuring the right values are returned
    from memory as we are mocking out any storage.
  """

  def init(_table_name, state), do: {:ok, state}

  def reset(_table_name, state), do: {:ok, :reset, state}

  def state(table_name, state), do: all(table_name, state)

  def put(_key, value, _table_name, state) do
    {:ok, value, state}
  end

  def get(key, _table_name, state) do
    {:ok, state[key], state}
  end

  def all(_table_name, state), do: state
end
