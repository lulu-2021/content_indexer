defmodule ContentIndexer.TfIdf.Corpus.Server do
  @moduledoc """
    ** Summary **
      Corpus is a Genserver that simply holds the total number of docs in the index
  """

  use GenServer
  alias ContentIndexer.TfIdf.Corpus.Impl

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
    {:ok, corpus_size, _state} = Impl.init()
    %{corpus_size: corpus_size}
  end

  #-------------------------------------------#
  # - internal genserver call handler methods #
  #-------------------------------------------#

  # the corpus count
  def handle_call({:count}, _from, state) do
    count = state[:corpus_size] || 0
    {:reply, {:ok, count}, state}
  end

  # the simply the Genserver state + 1
  def handle_call({:increment}, _from, state) do
    corpus_size = state[:corpus_size] || 0
    {:ok, corpus_size, incremented_state} = Impl.increment(corpus_size)
    {:reply, {:ok, :incremented}, incremented_state}
  end

  # the simply the Genserver state + 1
  def handle_call({:decrement}, _from, state) do
    corpus_size = state[:corpus_size] || 0
    {:ok, corpus_size, decremented_state} = Impl.decrement(corpus_size)
    {:reply, {:ok, :decremented}, decremented_state}
  end

  # the corpus count is simply resetting the Genserver state to zero!
  def handle_call({:reset}, _from, _state) do
    reset_state = Impl.reset()
    {:reply, {:ok, :reset}, reset_state}
  end
end
