defmodule ContentIndexer.TfIdf.DocTerms.Impl do
  @moduledoc """
    ** Summary **
    functions used by the `ContentIndexer.TfIdf.DocTerms.Server`
  """

  @doc """
    Resets the document counts

    ## Example

      iex> ContentIndexer.TfIdf.DocCounts.Impl.reset
            %{}
  """
  def reset, do: %{}

  @doc """
    Retrieves the document state

    ## Example

      iex> ContentIndexer.TfIdf.DocCounts.Impl.state
            %{}
  """
  def state(state), do: state

  @doc """
    retrieves the document term count

    ## Example

      iex> ContentIndexer.TfIdf.DocTerms.Impl.get_document_term_count("test_file_1.md", "bread")
            23
  """
  def get_document_term_count(document_name, term, document_map) do
    document_map["#{document_name}___#{term}"] || 0
  end

  @doc """
    If the document exists update the term and count, if it's a new document
    add it and it's respective term & term_count

    ## Example

      iex> ContentIndexer.TfIdf.DocTerms.Impl.add_document_term_count("test_file_1.md", "bread", 23)
            {"test_file_1.md", "bread, 23}
  """
  def add_document_term_count(document_name, term, count, document_map) do
    key = "#{document_name}___#{term}"
    case Map.has_key?(document_map, key) do
      true ->
        %{document_map | key => count}
      _ ->
        Map.put(document_map, key, count)
    end
  end
end
