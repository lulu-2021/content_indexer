defmodule ContentIndexer.Services.CalculatorTest do
  use ContentIndexer.Support.LibCase

  alias ContentIndexer.Services.{Calculator}

  @test_tokens_doc_1 [
    "docx", "file", "name", "duplic", "applic", "icon", "displai", "user", "cross",
    "entiti", "basi", "refer", "suc038", "version", "goal", "duplic", "applic",
    "icon", "red", "person", "green", "person", "displai", "user", "cross",
    "entiti", "basi", "just", "parent", "entiti", "level", "actor", "hire",
    "manag", "user", "basic", "cours", "event", "candid", "appli", "two", "job",
    "sit", "side", "side", "sister", "entiti", "current", "user", "parent"
  ]

  @test_tokens_doc_2 [
    "name", "duplic", "applic", "icon", "displai", "user", "cross", "entiti",
    "basi", "refer", "suc038", "version", "goal", "duplic", "applic", "icon",
    "red", "person", "green", "person", "displai", "user", "cross", "entiti",
    "basi", "just", "parent", "entiti", "level", "actor", "hire", "manag", "user",
    "basic", "cours", "event", "candid", "appli", "two", "job", "sit", "side",
    "side", "sister", "entiti", "current", "user", "parent", "entiti", "see"
  ]

  test "calculates the content_indexer of each token in a document - using stream & OTP method to calculate" do
    corpus_of_tokens = [@test_tokens_doc_1, @test_tokens_doc_2]
    corpus_size = 2
    {:ok, token_content_indexers} = Calculator.calculate_content_indexer_documents(@test_tokens_doc_1, corpus_of_tokens, corpus_size)

    #IO.puts "\n\n START stream test\n"
    #IO.inspect token_content_indexers
    #IO.puts "\n END stream test\n\n"

    assert frequency_value(token_content_indexers, "docx") == 0.0
    assert frequency_value(token_content_indexers, "file") == 0.0
    assert frequency_value(token_content_indexers, "applic") == -0.016218604324326577
    assert frequency_value(token_content_indexers, "user") == -0.032437208648653154
  end


  test "calculates the content_indexer of each token in a document - using MY method to calculate" do
    corpus_of_tokens = [@test_tokens_doc_1, @test_tokens_doc_2]
    {:ok, token_content_indexers} = Calculator.calculate_content_indexer_documents(@test_tokens_doc_1, corpus_of_tokens)

    # IO.puts "\n\nMy TF-IDF\n\n"
    # IO.inspect token_content_indexers
    # IO.puts "\nDONE\n"

    assert frequency_value(token_content_indexers, "docx") == 0.0
    assert frequency_value(token_content_indexers, "file") == 0.0
    assert frequency_value(token_content_indexers, "applic") == -0.016218604324326577
    assert frequency_value(token_content_indexers, "user") == -0.032437208648653154
  end

  test "calculates the content_indexer of all tokens in a corpus_of_tokens - using the TFIDF/Lib method to verify" do
    corpus_of_tokens = [test_token_list_1(), test_token_list_2()]
    {:ok, token_content_indexers} = Calculator.calculate_tokens_againts_corpus(test_token_list_1(), corpus_of_tokens)

    assert token_value_from_list(token_content_indexers, "docx") == ["docx", 0.0]
    assert token_value_from_list(token_content_indexers, "file") == ["file", 0.0]
    assert token_value_from_list(token_content_indexers, "applic") == ["applic", -0.016218604324326577]
    assert token_value_from_list(token_content_indexers, "user") == ["user", -0.032437208648653154]
  end

  test "calculates the term frequency for all terms in a document" do
    {:ok, token_frequencies} = Calculator.calculate_tf_document(@test_tokens_doc_1)

    # - this is a sampling of the term frequencies
    assert frequency_value(token_frequencies, "docx") == 0.02
    assert frequency_value(token_frequencies, "applic") == 0.04
    assert frequency_value(token_frequencies, "file") == 0.02
    assert frequency_value(token_frequencies, "user") == 0.08
  end

  defp frequency_value(frequencies, key) do
    frequencies
    |> Enum.filter(fn(f) -> elem(f, 0) == key end)
    |> List.first
    |> elem(1)
  end

  test "calculates the word counts for all terms in a document" do
    {:ok, token_frequencies} = Calculator.calculate_token_count_document(@test_tokens_doc_1)

    # - this is a sampling of the term frequencies
    assert frequency_value(token_frequencies, "docx") == 1
    assert frequency_value(token_frequencies, "applic") == 2
    assert frequency_value(token_frequencies, "file") == 1
    assert frequency_value(token_frequencies, "user") == 4
  end

  defp token_value_from_list(token_list, token_key) do
    token_list
    |> Enum.map(fn(item) -> Tuple.to_list(item) end)
    |> Enum.filter(fn(item) ->
      [ key | _ ] = item
      key == token_key
    end)
    |> List.flatten
  end

  defp test_token_list_1 do
    @test_tokens_doc_1 |> Enum.map(fn(token) -> "#{token}," end) |> Enum.drop(-1) |> to_string
  end

  defp test_token_list_2 do
    @test_tokens_doc_2 |> Enum.map(fn(token) -> "#{token}," end) |> Enum.drop(-1) |> to_string
  end
end

