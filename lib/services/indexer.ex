defmodule ContentIndexer.Services.Indexer do
  @moduledoc """
    ** Summary **
      Indexer is a Genserver that holds the index state - basically a list of index structs that have the filename, tokens and weights
      Each time an index struct is added to the server/index the weightings are re-calculated. Since they are stored in memory the index searching is fast
  """

  use GenServer
  alias ContentIndexer.Services.{Calculator, Index}

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:ok, init_indexer()}
  end

  def init_indexer do
    IO.puts "\nInitialising Indexer\n"
    [] # initialise with an empty list
  end

  # - client functions

  def corpus_of_tokens do
    GenServer.call(__MODULE__, {:corpus_of_tokens})
  end

  def calculate do
    GenServer.call(__MODULE__, {:calculate})
  end

  def add(file_name, tokens) when is_list(tokens) do
    item = Index.new(file_name, tokens)
    GenServer.call(__MODULE__, {:add, item})
  end

  def documents do
    GenServer.call(__MODULE__, {:documents})
  end

  def retrieve_index do
    GenServer.call(__MODULE__, {:state})
  end

  def reset_index do
    GenServer.call(__MODULE__, {:reset_index})
  end

  # - internal genserver call handler methods

  def handle_call({:reset_index}, _from, _state) do
    {:reply, {:ok, []}, []}
  end

  def handle_call({:state}, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:add, index}, _from, state) do
    state = [index | state]
    # - after adding to the index we need to re-calculate the weightings
    weighted_state = calculate_weights(state)
    {:reply, {:ok, weighted_state}, weighted_state}
  end

  def handle_call({:calculate}, _from, state) do
    weighted_state = calculate_weights(state)
    {:reply, {:ok, weighted_state}, weighted_state}
  end

  def handle_call({:corpus_of_tokens}, _from, state) do
    corpus_of_tokens = get_corpus_of_tokens(state)
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

  defp calculate_weights(state) do
    corpus = get_corpus_of_tokens(state)
    state
    |> Enum.map(fn(i) ->
      {:ok, calculated_weights} = Calculator.calculate_content_indexer_documents(i.tokens, corpus)
      %Index{file_name: i.file_name, uuid: i.uuid, tokens: i.tokens, term_weights: calculated_weights}
    end)
  end

  defp get_corpus_of_tokens(state) do
    state
    |> Enum.map(fn(t) ->
      t.tokens
    end)
  end
end
