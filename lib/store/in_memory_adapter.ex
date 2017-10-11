defmodule ContentIndexer.Store.InMemoryAdapter do
  @moduledoc """
    in memory storeage adapter for the Corpus Genserver
    reall all this is doing is ensuring the right values are returned
    from memory as we are mocking out any storage.
  """
  alias ContentIndexer.Store.Utils

  def init(table_name, state), do: all(table_name, state)

  def reset(_table_name, _state), do: {:ok, :reset, %{}}

  def state(table_name, state), do: all(table_name, state)

  def put(key, value, _table_name, state) do
    updated_state = Utils.update_state(key, value, state)
    {:ok, value, updated_state}
  end

  def get(key, _table_name, state) do
    {:ok, state[key], state}
  end

  def all(_table_name, state), do: {:ok, state, state}
end
