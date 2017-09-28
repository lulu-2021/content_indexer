defmodule ContentIndexer.TfIdf.IndexProcessTest do
  use ContentIndexer.Support.LibCase
  alias ContentIndexer.Services.{PreProcess, SearchUtils, Similarity}
  alias ContentIndexer.TfIdf.WeightsIndexer

  setup do
    SearchUtils.build_weight_index("test/fixtures", &PreProcess.pre_process_content/2)
    :ok
  end

  test "testing the index against a number of words" do
    {:ok, documents} = WeightsIndexer.state()
    query_terms = ["music", "account", "trivial"] |> SearchUtils.compile_query(&PreProcess.pre_process_query/1)
    results = Similarity.compare(documents, query_terms)

    assert results == ["test1.md", "test3.md"]
  end

  test "testing the index against a single of term" do
    {:ok, documents} = WeightsIndexer.state()
    query_terms = ["music"] |> SearchUtils.compile_query(&PreProcess.pre_process_query/1)
    results = Similarity.compare(documents, query_terms)

    assert results == ["test3.md"]
  end

  test "testing the index against a bad term" do
    {:ok, documents} = WeightsIndexer.state()
    query_terms = ["invalid"] |> SearchUtils.compile_query(&PreProcess.pre_process_query/1)
    results = Similarity.compare(documents, query_terms)

    assert results == []
  end
end
