defmodule ContentIndexer.TfIdf.TermCounts do
  @moduledoc """
    ** Summary **
      TermCounts is a GenServer that contains the numbers of documents that have a term 't'
      Basically a map of all unique terms and their respective counts i.e. 1 per for each
      document that has this term
    """

  use GenServer

  def start_link do
    # the 2nd param is the arg passed to the `init` method
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:ok, init_term_counts()}
  end

  @doc """
    Initialises the Term Counts with an empty map
  """
  def init_term_counts do
    IO.puts "\nInitialising Term Counts\n"
    %{}
  end

  @doc """
    Resets the term counts

    ## Example

      iex> ContentIndexer.TfIdf.TermCounts.reset
      {:ok, :reset}
  """
  def reset do
    GenServer.call(__MODULE__, {:reset})
  end

  @doc """
    Retrieves the current set of term_counts i.e. the state

    ## Example

      iex> ContentIndexer.TfIdf.TermCounts.state
      {:ok, 0}
  """
  def state do
    GenServer.call(__MODULE__, {:state})
  end

  @doc """
    If the term exists increment the count, if it's a new term add and set count to 1

    ## Example

      iex> ContentIndexer.TfIdf.TermCounts.increment_term("bread")
      {:ok, {"bread", 3}}
  """
  def increment_term(term) do
    GenServer.call(__MODULE__, {:increment_term, term})
  end

  def term_count(term) do
    GenServer.call(__MODULE__, {:term_count, term})
  end

  #-------------------------------------------#
  # - internal genserver call handler methods #
  #-------------------------------------------#

  # the reset is simply resetting the Genserver state to an empty list
  def handle_call({:reset}, _from, _state) do
    {:reply, {:ok, :reset}, %{}}
  end

  # the state is simply returning the Genserver state
  def handle_call({:state}, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:term_count, term}, _from, state) do
    term_count = get_term_count(term, state)
    {:reply, {:ok, term_count}, state}
  end

  def handle_call({:increment_term, term}, _from, state) do
    {term_count, terms} = increment_term_count(term, state)
    {:reply, {:ok, {term, term_count}}, terms}
  end

  defp get_term_count(term, terms) do
    terms[term] || 0
  end

  defp increment_term_count(term, terms) do
    case Map.has_key?(terms, term) do
      true ->
        term_count = terms[term] + 1
        terms = %{terms | term => term_count}
        {term_count, terms}
        _ ->
        terms = Map.put(terms, term,1)
        {1, terms}
    end
  end
end
