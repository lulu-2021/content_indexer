defmodule ContentIndexer.TfIdf.Corpus do
  @moduledoc """
    ** Summary **
      Corpus is a Genserver that simply holds the total number of docs in the index
  """

  alias ContentIndexer.TfIdf.Corpus.Server
  @doc """
    Resets the corpus document count

    ## Example

      iex> ContentIndexer.TfIdf.Corpus.reset
      {:ok, 0}
  """
  def reset do
    GenServer.call(Server, {:reset})
  end

  @doc """
    Count of all documents in the index

    ## Example

      iex> ContentIndexer.TfIdf.Corpus.count
      {:ok, 23}
  """
  def count do
    GenServer.call(Server, {:count})
  end

  @doc """
    Increment the count of all documents in the index

    ## Example

      iex> ContentIndexer.TfIdf.Corpus.increment
      {:ok, :incremented}
  """
  def increment do
    GenServer.call(Server, {:increment})
  end

  @doc """
    Decrement the count of all documents in the index

    ## Example

      iex> ContentIndexer.TfIdf.Corpus.decrement
      {:ok, :decremented}
  """
  def decrement do
    GenServer.call(Server, {:decrement})
  end
end
