defmodule ContentIndexer.TfIdf.DocCounts.Server do
  @moduledoc """
    ** Summary **
      DocCounts is a GenServer that contains a map of documents with their respective
      total number of terms in the document
    """

  use GenServer
  alias ContentIndexer.TfIdf.DocCounts.Impl

  def start_link do
    # the 2nd param is the arg passed to the `init` method
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:ok, init_doc_counts()}
  end

  @doc """
    Initialises the Doc Counts with an empty map
  """
  def init_doc_counts do
    IO.puts "\nInitialising Doc Counts\n"
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
    retrieve_state = Impl.state(state)
    {:reply, {:ok, retrieve_state}, state}
  end

  def handle_call({:add_document, document_name, term_count}, _from, state) do
    new_state = Impl.add_new_document(document_name, term_count, state)
    {:reply, {:ok, {document_name, term_count}}, new_state}
  end

  def handle_call({:document_term_count, document_name}, _from, state) do
    term_count = Impl.find_term_count(document_name, state)
    {:reply, {:ok, {document_name, term_count}}, state}
  end
end
