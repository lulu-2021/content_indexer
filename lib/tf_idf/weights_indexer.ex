defmodule ContentIndexer.TfIdf.WeightsIndexer do
  @moduledoc """
    ** Summary **
      The WeightsIndex is the actual tf_idf list stored by document_name

      basically a list of tuples - each tuple has a document name and a
      list of tuples that in turn contain each term and respective weight
    """

  alias ContentIndexer.TfIdf.WeightsIndexer.Server

  @doc """
    Resets the weights index map with an empty map

    ## Example

      iex> ContentIndexer.TfIdf.WeightsIndexer.reset
      {:ok, :reset}
  """
  def reset do
    GenServer.call(Server, {:reset})
  end

  @doc """
    Retrieves the current set of weights i.e. the state

    ## Example

      iex> ContentIndexer.TfIdf.WeightsIndexer.state
      {:ok, [
          {"test_file_1.md", [{"butter", 0}, {"jam", -0.234}]},
          {"test_file_2.md", [{"apples", 0.6728}, {"oranges", 0}]}
        ]
      }
  """
  def state do
    GenServer.call(Server, {:state})
  end

  @doc """
    Adds a new item to the state - i.e. the document_name and associated list of tuples
    representing the terms and tf_idf weight

    ## Example

      iex> ContentIndexer.TfIdf.WeightsIndexer.add("test_file.md", [{"butter", -0.1732},{"jam",-0.1732}])
      {:ok, :added}
  """
  def add(document_name, term_weights) do
    GenServer.call(Server, {:add, document_name, term_weights})
  end
end
