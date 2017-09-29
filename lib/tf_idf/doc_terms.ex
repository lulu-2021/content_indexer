defmodule ContentIndexer.TfIdf.DocTerms do
  @moduledoc """
    ** Summary **
      DocTerms is a GenServer with a Map of tuples that has the document, and a count of
      each of the terms in the document

      The key is a combination of the document_name & term
    """
  alias ContentIndexer.TfIdf.DocTerms.Server

  @doc """
    Resets the document counts

    ## Example

      iex> ContentIndexer.TfIdf.DocCounts.reset
            {:ok, %{}}
  """
  def reset do
    GenServer.call(Server, {:reset})
  end

  @doc """
    Retrieves the current set of doc_counts i.e. the state

    ## Example

      iex> ContentIndexer.TfIdf.DocCounts.state
      {:ok, 0}
  """
  def state do
    GenServer.call(Server, {:state})
  end

  @doc """
    If the document exists update the term and count, if it's a new document
    add it and it's respective term & term_count

    ## Example

      iex> ContentIndexer.TfIdf.DocTerms.add_doc_term_count("test_file_1.md", "bread", 23)
            {:ok, {"test_file_1.md", "bread, 23}}
  """
  def add_doc_term_count(document_name, term, count) do
    GenServer.call(Server, {:add_doc_term_count, document_name, term, count})
  end

  @doc """
    retrieves the document term count

    ## Example

      iex> ContentIndexer.TfIdf.DocTerms.get_doc_term_count("test_file_1.md", "bread")
            {:ok, 23}
  """
  def get_doc_term_count(document_name, term) do
    GenServer.call(Server, {:get_doc_term_count, document_name, term})
  end
end
