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
    assert %{"file_1" => 1.0, "file_2" => 0.0, "file_3" => 0.0, "file_4" => 1.0, "file_5" => 1.0} = result

    reset_index()
  end

  test "end to end test adding files to the indexer & searching in the index for triangle & jam" do
    {:ok, documents} = Indexer.documents()
    query_terms = ["triangle", "jam"]
    {_, query} = Calculator.calculate_content_indexer_documents(query_terms, [query_terms], 1)
    result = Similarity.get_similarity(documents, query)
    assert %{"file_2" => 0.0, "file_1" => file_1, "file_3" => file_3, "file_4" => file_4, "file_5" => file_5} = result

    [file_1, file_3, file_4, file_5]
    |> Enum.each(fn(result) -> assert result != 0 end)

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
