defmodule ContentIndexer.TfIdf.TermCounts.Impl do
  @moduledoc """
    ** Summary **
    functions used by the `ContentIndexer.TfIdf.TermCounts.Server`
  """

  @doc """
    Resets the term counts

    ## Example

      iex> ContentIndexer.TfIdf.TermCounts.Impl.reset
            %{}
  """
  def reset, do: %{}

  @doc """
    Retrieves the current set of term_counts i.e. the state

    ## Example

      iex> ContentIndexer.TfIdf.TermCounts.Impl.state(%{})
            %{}
  """
  def state(state), do: state

  @doc """
    If the term exists get the count else zero

    ## Example

      iex> ContentIndexer.TfIdf.TermCounts.Impl.get_term_count("bread")
            3
  """
  def get_term_count(term, terms) do
    terms[term] || 0
  end

  @doc """
    If the term exists increment the count, if it's a new term add and set count to 1

    ## Example

      iex> ContentIndexer.TfIdf.TermCounts.increment_term_count("bread")
            {"bread", 3}
  """
  def increment_term_count(term, terms) do
    case Map.has_key?(terms, term) do
      true ->
        term_count = terms[term] + 1
        terms = %{terms | term => term_count}
        {term_count, terms}
        _ ->
        terms = Map.put(terms, term, 1)
        {1, terms}
    end
  end
end
