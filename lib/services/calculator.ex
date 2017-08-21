defmodule ContentIndexer.Services.Calculator do
  @moduledoc """
    ** Summary **
      calculates the content_indexer weights for a document of tokens against a corpus of tokenized documents

      https://en.wikipedia.org/wiki/Tf-idf

      ** What is Tf-Idf **

      tf–idf, short for term frequency–inverse document frequency, is a numerical statistic that is
      intended to reflect how important a word is to a document in a collection or corpus. It is often
      used as a weighting factor in information retrieval and text mining.


      This library supports calculating large datasets in parallel using the Erlang OTP based server and actors

      Currently the supported file types are plain-text, PDF and DOCX (xml)

      ** Basic Useage **

      Pass it a list of tokens and a corpus of tokens as a list of lists and it will return a list of tokens
      with corresponding content_indexer weights based on the corpus of tokens

      iex> ContentIndexerService.calculate_content_indexer_documents(
        ["bread","butter","jam"],
        [["red","brown","jam"],["blue","green","butter"],["pink","green","bread","jam"]]
      )
      {:ok, [bread: 0.3662040962227032, butter: 0.3662040962227032,jam: 0.3662040962227032]}

  """

  alias ContentIndexer.Services.Calculator

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:ok, init_calculator}
  end

  def init_calculator do
    IO.puts "\nInitialising Calculator\n"
  end

  def handle_call({:state}, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def total(count) do
    GenServer.call(__MODULE__, {:total, count})
  end

  def handle_call({:total, count}, _from, state) do

    {:reply, {:ok, state}, state}
  end

  @doc """
    calculates the content_indexer

    iex> ContentIndexerValidateService.calculate_tokens_againts_corpus(
      "bread,butter,jam",
      ["red,brown,jam","blue,green,butter","pink,green,bread,jam"]
    )
    {:ok,
      [
        {"bread", 0.13515503603605478},
        {"butter", 0.13515503603605478},
        {"jam", 0.0}
      ]
    }
  """
  def calculate_tokens_againts_corpus(content, corpus, debug_print \\ false) do
    if debug_print, do: debug_incoming_data(content, corpus, "LIB")
    token_list = Tfidf.calculate_all(content, corpus, &String.split(&1, ","))
    {:ok, token_list}
  end

  @doc """
    calculates the word count for each token in the list of tokens representing the document
    and returns a list of the tokens with their respective word counts

    iex> ContentIndexerService.calculate_token_count_document(["bread","butter","jam","jam","bread","bread"])
    {:ok, [bread: 3, butter: 1, jam: 2]}
  """
  def calculate_token_count_document(tokens) do
    token_stream = Stream.map(tokens, fn(token) ->
      {String.to_atom(token), word_count(token, tokens)}
    end)
    uniq_tokens = token_stream |> Stream.uniq |> Enum.to_list
    {:ok, uniq_tokens}
  end

  @doc """
    calculates the term frequency for each token in the list of tokens representing the document
    and returns a list of the tokens with their respective term frequencies

    iex> ContentIndexerService.calculate_tf_document(["bread","butter","jam","jam","bread","bread"])
    {:ok, [bread: 0.5, butter: 0.16666666666666666, jam: 0.3333333333333333]}
  """
  def calculate_tf_document(tokens) do
    token_stream = Stream.map(tokens, fn(token) ->
      {String.to_atom(token), tf(token, tokens)}
    end)
    uniq_tokens = token_stream |> Stream.uniq |> Enum.to_list
    {:ok, uniq_tokens}
  end

  @doc """
    calculates the content_indexer weights for each token in the query - weights the query against itself

    iex> ContentIndexerService.calculate_content_indexer_query(
      ["bread","butter","jam"]
    )
    {:ok, [bread: 0.0, butter: 0.0, jam: 0.0]}
  """
  def calculate_content_indexer_query(tokens, debug_print \\ false) do
    if debug_print, do: debug_incoming_data(tokens, [tokens], "MY")
    tokenized_tokens = case tokens do
      [ _ | _ ] ->
        tokens
      _ ->
        tokenize(tokens)
    end
    token_content_indexer_counts = tokenized_tokens
    |> Enum.uniq
    |> Enum.map(fn(token) ->
      {String.to_atom(token), (tf(token, tokenized_tokens) * idf_streamed(token, 1, [tokens]))}
    end)
    {:ok, token_content_indexer_counts}
  end

  @doc """
    calculates the content_indexer weights for each token in the list of tokens against the corpus of tokens

    iex> ContentIndexerService.calculate_content_indexer_documents(
      ["bread","butter","jam"],
      [["red","brown","jam"],["blue","green","butter"],["pink","green","bread","jam"]]
    )
    {:ok, [bread: 0.3662040962227032, butter: 0.3662040962227032,jam: 0.3662040962227032]}
  """
  def calculate_content_indexer_documents(tokens, corpus_of_tokens, corpus_size \\ 0, debug_print \\ false) do
    if corpus_size == 0, do: corpus_size = length(corpus_of_tokens) # this is so we can avoid calculating it again!
    case corpus_size do
      1 ->
        calculate_content_indexer_documents_single(tokens, corpus_of_tokens, debug_print)
      _ ->
        calculate_content_indexer_documents_multiple(tokens, corpus_of_tokens, corpus_size, debug_print)
    end
  end

  defp calculate_content_indexer_documents_single(tokens, corpus_of_tokens, debug_print) do
    if debug_print, do: debug_incoming_data(tokens, corpus_of_tokens, "MY")
    token_content_indexer_counts = tokens
    |> Enum.uniq
    |> Enum.map(fn(token) ->
      {String.to_atom(token), (tf(token, tokens) * idf(token, corpus_of_tokens))}
    end)

    {:ok, token_content_indexer_counts}
  end

  # The corpus_of_tokens has more than one document in it
  defp calculate_content_indexer_documents_multiple(tokens, corpus_of_tokens, corpus_size, debug_print) do
    if debug_print, do: debug_incoming_data(tokens, corpus_of_tokens, "MY")
    token_content_indexer_counts = tokens
    |> Enum.uniq
    |> Enum.map(fn(token) ->
      {String.to_atom(to_string(token)), (tf(token, tokens) * idf_streamed(token, corpus_size, corpus_of_tokens))}
    end)
    {:ok, token_content_indexer_counts}
  end

  defp idf_streamed(word, corpus_size, corpus_of_tokens) do
    :math.log(corpus_size / (1 + n_containing_calc(word, corpus_of_tokens, corpus_size)))
  end

  # Corpus of tokens is a list of tuples with the index being the second item in the tuple
  defp n_containing_calc(word, corpus_of_tokens, collection_size) do
    ContentIndexer.Services.ListCheckerServer.initialise_collection(collection_size, self)
    indexed_stream = Stream.with_index(corpus_of_tokens)
    indexed_stream |> Enum.each(fn(streamed_item) ->
      {tokens, index} = streamed_item
      ContentIndexer.Services.ListCheckerWorker.list(index, word, tokens)
    end)

    total = receive do
      {:total, count} ->
        count
    end
    total
  end

  def list_contains(list, item) do
    Enum.find(list, fn(cur_item) -> item == cur_item end) != nil
  end

  defp idf(word, corpus_of_tokens) do
    :math.log(length(corpus_of_tokens) / (1 + n_containing(word, corpus_of_tokens)))
  end

  defp tf(word, tokens) do
    word_count(word, tokens) / length(tokens)
  end

  defp word_count(word, tokens) do
    Enum.reduce(tokens, 0, fn(cur_word, acc) ->
      if cur_word == word, do: acc + 1, else: acc
    end)
  end

  defp content_indexer(word, tokens, corpus_of_tokens) do
    tf(word, text) * idf(word, corpus_of_tokens)
  end

  defp n_containing(word, corpus_of_tokens) do
    Enum.reduce(corpus_of_tokens, 0, fn(text, acc) ->
      if list_contains(text, word), do: acc + 1, else: acc
    end)
  end

  defp tokenize(text, split_char \\ ",") do
    split_str = String.split(text, split_char)
    split_str |> Enum.filter(fn x -> x != "" end) # remove empty elements
  end

  defp debug_incoming_data(content, corpus, function) do
    IO.puts "\nSTART Debug #{function}:\n"
    IO.puts inspect(content)
    IO.puts "---------------------"
    IO.puts inspect(corpus)
    IO.puts "\nEND Debug #{function}:\n"
  end
end

