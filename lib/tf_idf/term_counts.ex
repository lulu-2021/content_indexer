defmodule ContentIndexer.TfIdf.TermCounts do
  @moduledoc """
    ** Summary **
      TermCounts is a GenServer that contains the numbers of documents that have a term 't'
      Basically a map of all unique terms and their respective counts i.e. 1 per for each
      document that has this term
    """

  use GenServer
  alias ContentIndexer.TfIdf.TermCounts.Server

  @doc """
    Resets the term counts

    ## Example

      iex> ContentIndexer.TfIdf.TermCounts.reset
      {:ok, :reset}
  """
  def reset do
    GenServer.call(Server, {:reset})
  end

  @doc """
    Retrieves the current set of term_counts i.e. the state

    ## Example

      iex> ContentIndexer.TfIdf.TermCounts.state
      {:ok, 0}
  """
  def state do
    GenServer.call(Server, {:state})
  end

  @doc """
    If the term exists increment the count, if it's a new term add and set count to 1

    ## Example

      iex> ContentIndexer.TfIdf.TermCounts.increment_term("bread")
      {:ok, {"bread", 3}}
  """
  def increment_term(term) do
    GenServer.call(Server, {:increment_term, term})
  end

  def term_count(term) do
    GenServer.call(Server, {:term_count, term})
  end
end
