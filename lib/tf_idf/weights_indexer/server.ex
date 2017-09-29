defmodule ContentIndexer.TfIdf.WeightsIndexer.Server do
  @moduledoc """
    ** Summary **
      The WeightsIndex is the actual tf_idf list stored by document_name

      basically a list of tuples - each tuple has a document name and a
      list of tuples that in turn contain each term and respective weight
    """

  use GenServer
  alias ContentIndexer.TfIdf.WeightsIndexer.Impl

  def start_link do
    # the 2nd param is the arg passed to the `init` method
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:ok, init_weights_index()}
  end

  @doc """
    Initialises the weights index map with an empty list
  """
  def init_weights_index do
    IO.puts "\nInitialising Weights Index\n"
    []
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
    {:reply, {:ok, state}, retrieved_state}
  end

  # add a new doc_index struct to the Genserver state
  def handle_call({:add, document_name, term_weights}, _from, state) do
    new_state = Impl.add_doc_weights(document_name, term_weights, state)
    {:reply, {:ok, :added}, new_state}
  end
end
