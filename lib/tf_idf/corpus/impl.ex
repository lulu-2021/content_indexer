defmodule ContentIndexer.TfIdf.Corpus.Impl do
  @moduledoc """
    ** Summary **
    functions used by the `ContentIndexer.TfIdf.Corpus.Server`
  """
  alias ContentIndexer.Store.InMemoryAdapter

  def init(args), do: InMemoryAdapter.init(args)

  @doc """
    Increments the corpus document count

    ## Example

      iex> ContentIndexer.TfIdf.Corpus.Impl.increment(2)
            2
  """
  def increment(corpus_size) do
    new_corpus_size = corpus_size + 1
    InMemoryAdapter.put(:corpus_size, new_corpus_size)
    new_corpus_size
  end

  @doc """
    Decrements the corpus document count

    ## Example

      iex> ContentIndexer.TfIdf.Corpus.Impl.decrement(2)
            1
  """
  def decrement(corpus_size) do
    new_corpus_size = corpus_size - 1
    InMemoryAdapter.put(:corpus_size, new_corpus_size)
    new_corpus_size
  end

  @doc """
    Resets the corpus document count

    ## Example

      iex> ContentIndexer.TfIdf.Corpus.Impl.reset
            0
  """
  def reset(args), do: InMemoryAdapter.reset(args)
end
