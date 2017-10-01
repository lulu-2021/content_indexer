defmodule ContentIndexer.TfIdf.Corpus.Impl do
  @moduledoc """
    ** Summary **
    functions used by the `ContentIndexer.TfIdf.Corpus.Server`
  """
  #alias ContentIndexer.Store.InMemoryAdapter
  alias ContentIndexer.Store.DetsAdapter

  #@storage_adapter InMemoryAdapter
  @storage_adapter DetsAdapter

  def init(args) do
    {:ok, init_state} = @storage_adapter.init(args)
    init_state
  end

  @doc """
    Increments the corpus document count

    ## Example

      iex> ContentIndexer.TfIdf.Corpus.Impl.increment(2)
            2
  """
  def increment(corpus_size) do
    {:ok, new_corpus_size} = @storage_adapter.put(:corpus_size, corpus_size + 1)
    new_corpus_size
  end

  @doc """
    Decrements the corpus document count

    ## Example

      iex> ContentIndexer.TfIdf.Corpus.Impl.decrement(2)
            1
  """
  def decrement(corpus_size) do
    {:ok, new_corpus_size} = @storage_adapter.put(:corpus_size, corpus_size - 1)
    new_corpus_size
  end

  @doc """
    Resets the corpus document count

    ## Example

      iex> ContentIndexer.TfIdf.Corpus.Impl.reset
            0
  """
  def reset(args) do
    {:ok, reset_state} = @storage_adapter.reset(args)
    reset_state
  end
end
