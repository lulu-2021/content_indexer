defmodule ContentIndexer.Services.SimilarityIndexerTest do
  use ContentIndexer.Support.LibCase
  alias ContentIndexer.Indexer
  alias ContentIndexer.Services.{Calculator, Similarity}

  setup do
    build_index()
    :ok
  end

  test "end to end test adding files to the indexer & searching in the index for butter & bread" do
    {:ok, documents} = Indexer.documents()
    query_terms = ["butter", "bread"]
    {_, query} = Calculator.calculate_content_indexer_documents(query_terms, [query_terms], 1)
    result = Similarity.get_similarity(documents, query)
    assert result == %{"file_1" => 1.0, "file_2" => 0.0, "file_3" => 0.0, "file_4" => 1.0, "file_5" => 1.0}

    reset_index()
  end

  test "end to end test adding files to the indexer & searching in the index for triangle & jam" do
    {:ok, documents} = Indexer.documents()
    query_terms = ["triangle", "jam"]
    {_, query} = Calculator.calculate_content_indexer_documents(query_terms, [query_terms], 1)
    result = Similarity.get_similarity(documents, query)
    assert result == %{"file_2" => 0.0, "file_1" => 0.7071067811865475, "file_3" => 0.7071067811865476, "file_4" => 0.7071067811865475, "file_5" => 0.7071067811865475}

    reset_index()
  end

  defp build_index do
    Indexer.add("file_1", ["bread", "butter", "jam"])
    Indexer.add("file_2", ["tea", "coffee", "milk"])
    Indexer.add("file_3", ["dice", "triangle", "box"])
    Indexer.add("file_4", ["bread", "butter", "jam"])
    Indexer.add("file_5", ["bread", "butter", "jam"])
  end

  defp reset_index do
    Indexer.reset_index()
  end
end
