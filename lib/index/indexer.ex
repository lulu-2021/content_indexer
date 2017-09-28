defmodule ContentIndexer.Indexer do
  @moduledoc """
    ** Summary **
      Indexer is a Genserver that holds the index state - basically a list of index structs that have the filename, tokens and weights
      Each time an index struct is added to the server/index the weightings are re-calculated. Since they are stored in memory the index searching is fast
  """

  use GenServer
  alias ContentIndexer.{Index, IndexInitialiser}

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:ok, init_indexer()}
  end

  @doc """
    Initialises the Index with an empty list
  """
  def init_indexer do
    IO.puts "\nInitialising Indexer\n"
    [] # initialise with an empty list
  end

  # - client functions

  def store_index(index_state) do
    GenServer.call(__MODULE__, {:store, index_state})
  end

  @doc """
    Retrieves a list of all the tokens in the entire index

    ## Example

      iex> ContentIndexer.Indexer.corpus_of_tokens
      {:ok,
        [["orange", "fruit", "basket", "apples"],
          ["bread", "butter", "jam", "mustard"]]}
  """
  def corpus_of_tokens do
    GenServer.call(__MODULE__, {:corpus_of_tokens})
  end

  @doc """
    Re calculates all the term_weights on the entire index

    ## Example

      iex>ContentIndexer.Indexer.calculate()
      {:ok,
        [%ContentIndexer.Index{file_name: "test_file_3.md",
          term_weights: [{"orange", 0.0}, {"fruit", 0.0}, {"basket", 0.0},
            {"apples", 0.0}], tokens: ["orange", "fruit", "basket", "apples"],
          uuid: "2c600089-b35d-4667-a146-4635bd282811"},
          %ContentIndexer.Index{file_name: "test_file_2.md",
          term_weights: [{"orange", 0.0}, {"fruit", 0.0}, {"basket", 0.0},
            {"apples", 0.0}], tokens: ["orange", "fruit", "basket", "apples"],
          uuid: "c62c65be-4ac6-46bc-9597-2d70c65fa1a0"},
          %ContentIndexer.Index{file_name: "test_file.md",
          term_weights: [{"bread", 0.1013662770270411}, {"butter", 0.1013662770270411},
            {"jam", 0.1013662770270411}, {"mustard", 0.1013662770270411}],
          tokens: ["bread", "butter", "jam", "mustard"],
          uuid: "18693629-bfa9-4ffc-8fe8-ebc0c5c72c7b"}]}
  """
  def calculate do
    GenServer.call(__MODULE__, {:calculate})
  end

  @doc """
    Adds a new file_name and associated list of tokens to the index

    ## Parameters

      - file_name: String that represents the file that has the content to be indexed
      - tokens: List of Strings that are the tokenised content

    ## Example

      iex> ContentIndexer.Indexer.add("test_file.md", ["bread", "butter", "jam", "mustard"])
      {:ok,
        [%ContentIndexer.Index{file_name: "test_file.md",
          term_weights: [{"bread", -0.17328679513998632},
            {"butter", -0.17328679513998632}, {"jam", -0.17328679513998632},
            {"mustard", -0.17328679513998632}],
          tokens: ["bread", "butter", "jam", "mustard"],
          uuid: "18693629-bfa9-4ffc-8fe8-ebc0c5c72c7b"}]}
  """
  def add(file_name, tokens) when is_list(tokens) do
    item = Index.new(file_name, tokens)
    GenServer.call(__MODULE__, {:add, item})
  end

  @doc """
    Returns a nested list of all the individual index items containing their file_name and associated tokens with weights

    ## Example

      iex> ContentIndexer.Indexer.documents()
      {:ok,
      [{"test_file_3.md",
        [{"orange", 0.0}, {"fruit", 0.0}, {"basket", 0.0}, {"apples", 0.0}]},
        {"test_file_2.md",
        [{"orange", 0.0}, {"fruit", 0.0}, {"basket", 0.0}, {"apples", 0.0}]},
        {"test_file.md",
        [{"bread", 0.1013662770270411}, {"butter", 0.1013662770270411},
          {"jam", 0.1013662770270411}, {"mustard", 0.1013662770270411}]}]}
  """
  def documents do
    GenServer.call(__MODULE__, {:documents})
  end

  @doc """
    Retrieves the entire index
  """
  def retrieve_index do
    GenServer.call(__MODULE__, {:state})
  end

  @doc """
    Resets the index with an empty list
  """
  def reset_index do
    GenServer.call(__MODULE__, {:reset_index})
  end

  # - internal genserver call handler methods

  def handle_call({:store, index_state}, _from, _state) do
    state = index_state
    {:reply, {:ok, state}, state}
  end

  def handle_call({:reset_index}, _from, _state) do
    {:reply, {:ok, []}, []}
  end

  def handle_call({:state}, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:add, index}, _from, state) do
    state = [index | state]
    # - after adding to the index we need to re-calculate the weightings
    weighted_state = IndexInitialiser.initialise_index(state)
    {:reply, {:ok, weighted_state}, weighted_state}
  end

  def handle_call({:calculate}, _from, state) do
    weighted_state = IndexInitialiser.initialise_index(state)
    {:reply, {:ok, weighted_state}, weighted_state}
  end

  def handle_call({:corpus_of_tokens}, _from, state) do
    corpus_of_tokens = IndexInitialiser.get_corpus_of_tokens(state)
    {:reply, {:ok, corpus_of_tokens}, state}
  end

  def handle_call({:documents}, _from, state) do
    documents = retrieve_as_documents(state)
    {:reply, {:ok, documents}, state}
  end

  # private methods used by the internal handle_call methods

  defp retrieve_as_documents(state) do
    state
    |> Enum.map(fn(d) ->
      {d.file_name, d.term_weights}
    end)
  end
end
