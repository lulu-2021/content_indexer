defmodule ContentIndexer.IndexInitialiser do
  @moduledoc """
  """
  alias ContentIndexer.{Index, Services.Calculator}

  def initialise_index, do: initialise_index([])
  def initialise_index(state) do
    corpus = get_corpus_of_tokens(state)
    state
    |> Enum.map(fn(i) ->
      {:ok, calculated_weights} = Calculator.calculate_content_indexer_documents(i.tokens, corpus)
      %Index{file_name: i.file_name, uuid: i.uuid, tokens: i.tokens, term_weights: calculated_weights}
    end)
  end

  def get_corpus_of_tokens(state) do
    state
    |> Enum.map(fn(t) ->
      t.tokens
    end)
  end
end
