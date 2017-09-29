defmodule ContentIndexer.TfIdf.DocCounts do
  @moduledoc """
    ** Summary **
      DocCounts is a GenServer that contains a map of documents with their respective
      total number of terms in the document
  """

  alias ContentIndexer.TfIdf.DocCounts.Server

  @doc """
    Resets the document counts

    ## Example

      iex> ContentIndexer.TfIdf.DocCounts.reset
      {:ok, 0}
  """
  def reset do
    GenServer.call(Server, {:reset})
  end

  @doc """
    Retrieves the current set of doc_counts i.e. the state

    ## Example

      iex> ContentIndexer.TfIdf.DocCounts.state
      {:ok, %{}}
  """
  def state do
    GenServer.call(Server, {:state})
  end

  @doc """
    If the document exists update the count, if it's a new document
    add it and it's respective term_count

    ## Example

      iex> ContentIndexer.TfIdf.DocCounts.add_document("test_file_1.md", 23)
      {:ok, {"test_file_1.md", 23}}
  """
  def add_document(document_name, term_count) do
    GenServer.call(Server, {:add_document, document_name, term_count})
  end

  @doc """
    Retrieves the current term_count for this document or nil if not in the map

    ## Example

      iex> ContentIndexer.TfIdf.DocCounts.document_term_count("test_file_1.md")
      {:ok, {"test_file_1.md", 23}}
  """
  def document_term_count(document_name) do
    GenServer.call(Server, {:document_term_count, document_name})
  end
end
