defmodule ContentIndexer.TfIdf.DocTerms do
  @moduledoc """
    ** Summary **
      DocTerms is a GenServer with a Map of tuples that has the document, and a count of
      each of the terms in the document

      The key is a combination of the document_name & term
    """

  use GenServer

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

  @doc """
    Resets the document counts

    ## Example

      iex> ContentIndexer.TfIdf.DocCounts.reset
      {:ok, 0}
  """
  def reset do
    GenServer.call(__MODULE__, {:reset})
  end

  @doc """
    Retrieves the current set of doc_counts i.e. the state

    ## Example

      iex> ContentIndexer.TfIdf.DocCounts.state
      {:ok, 0}
  """
  def state do
    GenServer.call(__MODULE__, {:state})
  end

  @doc """
    If the document exists update the term and count, if it's a new document
    add it and it's respective term & term_count

    ## Example

      iex> ContentIndexer.TfIdf.DocTerms.add_doc_term_count("test_file_1.md", "bread", 23)
      {:ok, {"test_file_1.md", "bread, 23}}
  """
  def add_doc_term_count(document_name, term, count) do
    GenServer.call(__MODULE__, {:add_doc_term_count, document_name, term, count})
  end

  def get_doc_term_count(document_name, term) do
    GenServer.call(__MODULE__, {:get_doc_term_count, document_name, term})
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

  def handle_call({:get_doc_term_count, document_name, term}, _from, state) do
    count = get_document_term_count(document_name, term, state)
    {:reply, {:ok, count}, state}
  end

  def handle_call({:add_doc_term_count, document_name, term, count}, _from, state) do
    new_state = add_document_term_count(document_name, term, count, state)
    {:reply, {:ok, {document_name, term, count}}, new_state}
  end

  defp get_document_term_count(document_name, term, document_map) do
    document_map["#{document_name}___#{term}"] || 0
  end

  defp add_document_term_count(document_name, term, count, document_map) do
    key = "#{document_name}___#{term}"
    case Map.has_key?(document_map, key) do
      true ->
        %{document_map | key => count}
      _ ->
        Map.put(document_map, key, count)
    end
  end
end
