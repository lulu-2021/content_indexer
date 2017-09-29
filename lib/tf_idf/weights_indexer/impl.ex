defmodule ContentIndexer.TfIdf.WeightsIndexer.Impl do
  @moduledoc """
    ** Summary **
    functions used by the `ContentIndexer.TfIdf.WeightsIndexer.Server`
  """

  @doc """
    Resets the weights index map with an empty map

    ## Example

      iex> ContentIndexer.TfIdf.WeightsIndexer.Impl.reset
            []
  """
  def reset, do: []

  @doc """
    Retrieves the current set of weights i.e. the state

    ## Example

      iex> ContentIndexer.TfIdf.WeightsIndexer.Impl.state
        [
          {"test_file_1.md", [{"butter", 0}, {"jam", -0.234}]},
          {"test_file_2.md", [{"apples", 0.6728}, {"oranges", 0}]}
        ]
  """
  def state(state), do: state

  @doc """
    Adds a new item to the state - i.e. the document_name and associated list of tuples
    representing the terms and tf_idf weight

    ## Example

      iex> ContentIndexer.TfIdf.WeightsIndexerImpl.add_doc_weights("test_file.md", [{"butter", -0.1732},{"jam",-0.1732}])
  """
  def add_doc_weights(document_name, term_weights, documents) do
    [{document_name, term_weights} | documents]
  end
end
