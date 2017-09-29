defmodule ContentIndexer.TfIdf.DocCounts.Impl do
  @moduledoc """
    ** Summary **
    functions used by the `ContentIndexer.TfIdf.DocCounts.Server`
  """

  @doc """
    Resets the document counts

    ## Example

      iex> ContentIndexer.TfIdf.DocCounts.Impl.reset()
        %{}
  """
  def reset, do: %{}

  @doc """
    Returns the document counts state

    ## Example

      iex> ContentIndexer.TfIdf.DocCounts.Impl.state()
        %{}
  """
  def state(state), do: state

  @doc """
    Retrieves the current term_count for this document or nil if not in the map

    ## Example

      iex> ContentIndexer.TfIdf.DocCounts.Impl.document_term_count("test_file_1.md")
          {"test_file_1.md", 23}
  """
  def find_term_count(document_name, document_map) do
    document_map[document_name]
  end

  @doc """
    If the document exists update the count, if it's a new document
    add it and it's respective term_count

    ## Example

      iex> ContentIndexer.TfIdf.DocCounts.Impl.add_document("test_file_1.md", 23)
            {"test_file_1.md", 23}
  """
  def add_new_document(document_name, term_count, document_map) do
    case Map.has_key?(document_map, document_name) do
      true ->
        %{document_map | document_name => term_count}
      _ ->
        Map.put(document_map, document_name, term_count)
    end
  end
end
