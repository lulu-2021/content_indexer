defmodule ContentIndexer.TfIdf.DocTerms.Server do
  @moduledoc """
    ** Summary **
      DocTerms is a GenServer with a Map of tuples that has the document, and a count of
      each of the terms in the document

      The key is a combination of the document_name & term
    """

  use GenServer
  alias ContentIndexer.TfIdf.DocTerms.Impl

  def start_link do
    # the 2nd param is the arg passed to the `init` method
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:ok, init_doc_terms()}
  end

  @doc """
    Initialises the Doc Terms with an empty map
  """
  def init_doc_terms do
    IO.puts "\nInitialising Doc Terms\n"
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
    {:reply, {:ok, state}, retrieved_state}
  end

  def handle_call({:get_doc_term_count, document_name, term}, _from, state) do
    count = Impl.get_document_term_count(document_name, term, state)
    {:reply, {:ok, count}, state}
  end

  def handle_call({:add_doc_term_count, document_name, term, count}, _from, state) do
    new_state = Impl.add_document_term_count(document_name, term, count, state)
    {:reply, {:ok, {document_name, term, count}}, new_state}
  end

end
