defmodule ContentIndexer.TfIdf.WeightsIndexer do
  @moduledoc """
    ** Summary **
      The WeightsIndex is the actual tf_idf list stored by document_name

      basically a list of tuples - each tuple has a document name and a
      list of tuples that in turn contain each term and respective weight
    """

  use GenServer

  def start_link do
    # the 2nd param is the arg passed to the `init` method
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:ok, init_weights_index()}
  end

  @doc """
    Initialises the weights index map with an empty list
  """
  def init_weights_index do
    IO.puts "\nInitialising Weights Index\n"
    []
  end

  @doc """
    Resets the weights index map with an empty map

    ## Example

      iex> ContentIndexer.TfIdf.WeightsIndexer.reset
      {:ok, :reset}
  """
  def reset do
    GenServer.call(__MODULE__, {:reset})
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
    GenServer.call(__MODULE__, {:state})
  end

  @doc """
    Adds a new item to the state - i.e. the document_name and associated list of tuples
    representing the terms and tf_idf weight

    ## Example

      iex> ContentIndexer.TfIdf.WeightsIndexer.add("test_file.md", [{"butter", -0.1732},{"jam",-0.1732}])
      {:ok, :added}
  """
  def add(document_name, term_weights) do
    GenServer.call(__MODULE__, {:add, document_name, term_weights})
  end

  #-------------------------------------------#
  # - internal genserver call handler methods #
  #-------------------------------------------#

  # the reset is simply resetting the Genserver state to an empty list
  def handle_call({:reset}, _from, _state) do
    {:reply, {:ok, :reset}, []}
  end

  # the state is simply returning the Genserver state
  def handle_call({:state}, _from, state) do
    {:reply, {:ok, state}, state}
  end

  # add a new doc_index struct to the Genserver state
  def handle_call({:add, document_name, term_weights}, _from, state) do
    new_state = add_doc_weights(document_name, term_weights, state)
    {:reply, {:ok, :added}, new_state}
  end

  defp add_doc_weights(document_name, term_weights, documents) do
    documents = [{document_name, term_weights} | documents]
  end
end
