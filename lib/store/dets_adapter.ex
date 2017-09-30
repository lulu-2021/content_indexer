defmodule ContentIndexer.Store.DetsAdapter do
  @moduledoc """
    Erlang DETS storeage adapter for the Corpus Genserver
  """

  @dets_table_name :corpus # eventually get this from ENV

  @doc """
    initialise the DETS table as a set with unique keys
  """
  def init(_args) do
    case :dets.open_file(@dets_table_name, [type: :set]) do
      {:ok, dets_table} -> {:ok, dets_table}
      _ -> {:error, "failed to open Dets table: #{@dets_table_name}"}
    end
  end

  @doc """
    by using a tuple of dets_table_name & the key as a composite key
    it allows us later to match easier to retrieve all the records with this
    composite key
  """
  def put(key, value) do
    case :dets.insert(@dets_table_name, {{@dets_table_name, key}, value}) do
      :ok -> {:ok, "insert completed!"}
      _ -> {:error, "insert failed!"}
    end
  end

  def get(key) do
    case :dets.lookup(@dets_table_name, {@dets_table_name, key}) do
      [{{@dets_table_name, ^key}, value}] -> {:ok, value}
      [] -> {:error, "#{key} not found!"}
    end
  end

  def all do
    :dets.match_object(@dets_table_name, {{@dets_table_name, :_}, :_})
  end
end
