defmodule ContentIndexer.TfIdf.TermCounts.Server do
  @moduledoc """
    ** Summary **
      TermCounts is a GenServer that contains the numbers of documents that have a term 't'
      Basically a map of all unique terms and their respective counts i.e. 1 per for each
      document that has this term
    """

  use GenServer
  alias ContentIndexer.TfIdf.TermCounts.Impl

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

  #-------------------------------------------#
  # - internal genserver call handler methods #
  #-------------------------------------------#

  # the reset is simply resetting the Genserver state to an empty list
  def handle_call({:reset}, _from, _state) do
    reset_state = Impl.reset()
    {:reply, {:ok, :reset}, reset_state}
  end

  # the state is simply returning the Genserver state
  def handle_call({:state}, _from, state) do
    retrieved_state = Impl.state(state)
    {:reply, {:ok, retrieved_state}, state}
  end

  def handle_call({:term_count, term}, _from, state) do
    term_count = Impl.get_term_count(term, state)
    {:reply, {:ok, term_count}, state}
  end

  def handle_call({:increment_term, term}, _from, state) do
    {term_count, terms} = Impl.increment_term_count(term, state)
    {:reply, {:ok, {term, term_count}}, terms}
  end
end
