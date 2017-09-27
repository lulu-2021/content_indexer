defmodule ContentIndexer.Services.SimilarityFileIndexerTest do
  use ContentIndexer.Support.LibCase
  alias ContentIndexer.Indexer
  alias ContentIndexer.Services.{PreProcess, SearchUtils, Similarity}

  setup do
    SearchUtils.build_index("test/fixtures", &PreProcess.pre_process_content/2)
    :ok
  end

  test "end to end test adding real markdown files to the indexer & searching : praising" do
    {:ok, documents} = Indexer.documents()
    query_terms = ["praising"] |> SearchUtils.compile_query(&PreProcess.pre_process_query/1)
    results = Similarity.compare(documents, query_terms)

    assert results == ["test3.md"]
    reset_index()
  end

  test "end to end test adding real markdown files to the indexer & searching : three" do
    {:ok, documents} = Indexer.documents()
    query_terms = ["three"] |> SearchUtils.compile_query(&PreProcess.pre_process_query/1)
    results = Similarity.compare(documents, query_terms)

    valid_results?(["test1.md", "test2.md", "test3.md"], results)
    reset_index()
  end

  test "end to end test adding real markdown files to the indexer & searching : denounce, pleasure, praising" do
    {:ok, documents} = Indexer.documents()
    query_terms = ["denounce", "pleasure", "praising"] |> SearchUtils.compile_query(&PreProcess.pre_process_query/1)
    results = Similarity.compare(documents, query_terms)

    valid_results?(["test2.md", "test3.md", "test1.md"], results)
    reset_index()
  end

  test "end to end test adding real markdown files to the indexer & searching 2 key words" do
    {:ok, documents} = Indexer.documents()
    query_terms = ["trivial", "instrument"] |> SearchUtils.compile_query(&PreProcess.pre_process_query/1)
    results = Similarity.compare(documents, query_terms)

    valid_results?(["test1.md", "test3.md"], results)
    reset_index()
  end

  test "end to end test adding real markdown files to the indexer & searching 5 key words" do
    {:ok, documents} = Indexer.documents()
    query_terms = ["physical", "instrument", "cook"] |> SearchUtils.compile_query(&PreProcess.pre_process_query/1)
    results = Similarity.compare(documents, query_terms)

    valid_results?(["test1.md", "test2.md", "test3.md"], results)
    reset_index()
  end

  test "end to end test adding real markdown files to the indexer & searching non existant words" do
    {:ok, documents} = Indexer.documents()
    query_terms = ["peanut", "germany"] |> SearchUtils.compile_query(&PreProcess.pre_process_query/1)
    results = Similarity.compare(documents, query_terms)

    assert results == []
    reset_index()
  end

  defp valid_results?(list, results) do
    list
    |> Enum.each(fn(x) ->
      assert Enum.member?(results, x)
    end)
  end

  defp reset_index do
    Indexer.reset_index()
  end
end
