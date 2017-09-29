defmodule ContentIndexer.TfIdf.Corpus.Impl do
  @moduledoc """
    ** Summary **
    functions used by the `ContentIndexer.TfIdf.Corpus.Server`
  """

  @doc """
    Increments the corpus document count

    ## Example

      iex> ContentIndexer.TfIdf.Corpus.Impl.increment(2)
            2
  """
  def increment(corpus_size) do
    corpus_size + 1
  end

  @doc """
    Decrements the corpus document count

    ## Example

      iex> ContentIndexer.TfIdf.Corpus.Impl.decrement(2)
            1
  """
  def decrement(corpus_size) do
    corpus_size - 1
  end

  @doc """
    Resets the corpus document count

    ## Example

      iex> ContentIndexer.TfIdf.Corpus.Impl.reset
            0
  """
  def reset, do: 0
end
