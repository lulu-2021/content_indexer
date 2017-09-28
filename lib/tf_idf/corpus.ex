defmodule ContentIndexer.TfIdf.Corpus do
  @moduledoc """
    ** Summary **
      Corpus is a Genserver that simply holds the total number of docs in the index
  """

  use GenServer

  def start_link do
    # the 2nd param is the arg passed to the `init` method
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:ok, init_corpus()}
  end

  @doc """
    Initialises the Corpus doc count with zero
  """
  def init_corpus do
    IO.puts "\nInitialising Corpus count\n"
    0
  end

  @doc """
    Resets the corpus document count

    ## Example

      iex> ContentIndexer.TfIdf.Corpus.reset
      {:ok, 0}
  """
  def reset do
    GenServer.call(__MODULE__, {:reset})
  end

  @doc """
    Count of all documents in the index

    ## Example

      iex> ContentIndexer.TfIdf.Corpus.count
      {:ok, 23}
  """
  def count do
    GenServer.call(__MODULE__, {:count})
  end

  @doc """
    Increment the count of all documents in the index

    ## Example

      iex> ContentIndexer.TfIdf.Corpus.increment
      {:ok, :incremented}
  """
  def increment do
    GenServer.call(__MODULE__, {:increment})
  end

  @doc """
    Decrement the count of all documents in the index

    ## Example

      iex> ContentIndexer.TfIdf.Corpus.decrement
      {:ok, :decremented}
  """
  def decrement do
    GenServer.call(__MODULE__, {:decrement})
  end

  #-------------------------------------------#
  # - internal genserver call handler methods #
  #-------------------------------------------#

  # the corpus count is simply the Genserver state!
  def handle_call({:count}, _from, state) do
    {:reply, {:ok, state}, state}
  end

  # the simply the Genserver state + 1
  def handle_call({:increment}, _from, state) do
    incremented_state = state + 1
    {:reply, {:ok, :incremented}, incremented_state}
  end

  # the simply the Genserver state + 1
  def handle_call({:decrement}, _from, state) do
    decremented_state = state - 1
    {:reply, {:ok, :decremented}, decremented_state}
  end

  # the corpus count is simply resetting the Genserver state to zero!
  def handle_call({:reset}, _from, _state) do
    {:reply, {:ok, :reset}, 0}
  end
end
