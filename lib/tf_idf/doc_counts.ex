defmodule ContentIndexer.TfIdf.DocCounts do
  @moduledoc """
    ** Summary **
      DocCounts is a GenServer that contains a map of documents with their respective
      total number of terms in the document
    """

  use GenServer

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
    If the document exists update the count, if it's a new document
    add it and it's respective term_count

    ## Example

      iex> ContentIndexer.TfIdf.DocCounts.add_document("test_file_1.md", 23)
      {:ok, {"test_file_1.md", 23}}
  """
  def add_document(document_name, term_count) do
    GenServer.call(__MODULE__, {:add_document, document_name, term_count})
  end

  @doc """
    Retrieves the current term_count for this document or nil if not in the map

    ## Example

      iex> ContentIndexer.TfIdf.DocCounts.document_term_count("test_file_1.md")
      {:ok, {"test_file_1.md", 23}}
  """
  def document_term_count(document_name) do
    GenServer.call(__MODULE__, {:document_term_count, document_name})
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

  def handle_call({:add_document, document_name, term_count}, _from, state) do
    new_state = add_new_document(document_name, term_count, state)
    {:reply, {:ok, {document_name, term_count}}, new_state}
  end

  def handle_call({:document_term_count, document_name}, _from, state) do
    term_count = find_term_count(document_name, state)
    {:reply, {:ok, {document_name, term_count}}, state}
  end

  defp find_term_count(document_name, document_map) do
    document_map[document_name]
  end

  defp add_new_document(document_name, term_count, document_map) do
    case Map.has_key?(document_map, document_name) do
      true ->
        %{document_map | document_name => term_count}
      _ ->
        Map.put(document_map, document_name, term_count)
    end
  end
end
