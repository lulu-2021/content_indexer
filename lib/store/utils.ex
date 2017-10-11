defmodule ContentIndexer.Store.Utils do
  @moduledoc """
    common functions used by the adapters
  """

  def dets_all_to_map(dets_map) do
    dets_map
    |> Enum.reduce(%{}, fn(x, acc) ->
      keys = elem(x, 0)
      Map.put(acc, elem(keys, 1), elem(x, 1))
    end)
  end

  def update_state(key, value, state) do
    case Map.has_key?(state, key) do
      true ->
        %{state | key => value}
      _ ->
        Map.put(state, key, value)
    end
  end
end
