defmodule ContentIndexer.Store.DetsAdapter do
  @moduledoc """
    Erlang DETS storeage adapter for the Corpus Genserver
  """

  @doc """
    initialise the DETS table as a set with unique keys
  """
  def init(_args, table_name) do
    case :dets.open_file(table_name, [type: :set]) do
      {:ok, _dets_table} ->
        init_state = all(table_name)
        {:ok, init_state}
      _ ->
        {:error, "failed to open Dets table: #{table_name}"}
    end
  end

  def reset(args, table_name) do
    :dets.delete_all_objects(table_name)
    {:ok, args}
  end

  def state(table_name) do
    all(table_name)
  end

  @doc """
    by using a tuple of dets_table_name & the key as a composite key
    it allows us later to match easier to retrieve all the records with this
    composite key
  """
  def put(key, value, table_name) do
    case :dets.insert(table_name, {{table_name, key}, value}) do
      :ok -> {:ok, value}
      _ -> {:error, "insert failed!"}
    end
  end

  def get(key, table_name) do
    case :dets.lookup(table_name, {table_name, key}) do
      [{{^table_name, ^key}, value}] -> {:ok, value}
      [] -> {:error, "#{key} not found!"}
    end
  end

  def all(table_name) do
    :dets.match_object(table_name, {{table_name, :_}, :_})
  end
end
