defmodule ContentIndexer.TfIdf.Calculate do
  @moduledoc """
    Calculate the TF_IDF weights for a given document_name tokens
  """

  alias ContentIndexer.TfIdf.{Corpus, DocCounts, DocTerms, TermCounts, WeightsIndexer}

  @doc """
    Retrieves the current set of weights i.e. the state

    ## Parameters

      - document_name: String - document name
      - tokens: List of tokens each being a String

    ## Example

      iex> ContentIndexer.TfIdf.Calculate.tf_idf("test_file.md", ["bread","butter"])
      {:ok, [
          {"test_file_1.md", [{"butter", 0}, {"bread", -0.234}]},
        ]
      }
  """
  def tf_idf(document_name, tokens) do
    #
    # Parallelise (1) & (2) & once they are all completed
    #
    # Put (3-5) into a Task await/async - with a longish wait time!
    #
    # (1) Count the total number of terms in the doc & Add this to DocCounts
    total_number_of_terms_in_document = Enum.count(tokens)
    DocCounts.add_document(document_name, total_number_of_terms_in_document)

    # (2) Increment the total number of documents in the Corpus Count
    Corpus.increment()

    # (3 & 4 & 5) Number of times each term appears in the document
    {:ok, total_docs_in_corpus} = Corpus.count()
    weights = process_document_terms(document_name, tokens, total_docs_in_corpus)
    # Finally add the weights to the indexer for comparing & searching
    {:ok, :added} = WeightsIndexer.add(document_name, weights)
  end

  defp process_document_terms(document_name, tokens, corpus_count) do
    tokens
    |> unique_term_count
    |> Enum.map(fn(token) ->
      term = elem(token, 0)
      DocTerms.add_doc_term_count(document_name, term, elem(token, 1))
      # (4) Increment number of documents with term
      {:ok, {term, _term_count}} = TermCounts.increment_term(term)

      # (5) Calculate TF_IDF on each term
      calculate_tf_idf(term, document_name, corpus_count)
    end)
  end

  defp calculate_tf_idf(term, document_name, corpus_count) do
    term_tf = tf(term, document_name)
    term_idf = idf(term, corpus_count)
    {term, term_tf * term_idf}
  end

  # given a list of string tokens - this will return a list of tuples
  # with each tuple containing unique terms & counts in the tokens list
  defp unique_term_count(tokens) when is_list(tokens) do
    tokens_stream = tokens
    |> Enum.sort()
    |> Stream.chunk_by(fn arg -> arg end)
    |> Stream.map(fn(x) ->
      {List.first(x), Enum.count(x)}
    end)
    Enum.to_list(tokens_stream)
  end

  defp idf(term, corpus_count) do
    {:ok, number_of_docs_with_term} = TermCounts.term_count(term)
    :math.log(corpus_count / (1 + number_of_docs_with_term))
  end

  defp tf(term, document_name) do
    {:ok, doc_term_count} = DocTerms.get_doc_term_count(document_name, term)
    {:ok, {_doc, total_terms_in_doc}} = DocCounts.document_term_count(document_name)
    doc_term_count / total_terms_in_doc
  end
end
