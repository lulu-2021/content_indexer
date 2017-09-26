defmodule ContentIndexer.Services.SimilarityFileIndexerTest do
  use ContentIndexer.Support.LibCase
  alias ContentIndexer.Services.{SearchUtils, Indexer, Similarity}

  setup do
    SearchUtils.build_index("test/fixtures")
    :ok
  end

  test "end to end test adding real markdown files to the indexer & searching" do
    {:ok, documents} = Indexer.documents()
    query_terms = ["simple", "instrument"] |> SearchUtils.compile_query()
    results = Similarity.compare(documents, query_terms)

    assert results == ["test1.md", "test3.md"]
    reset_index()
  end

  defp reset_index do
    Indexer.reset_index()
  end
end
