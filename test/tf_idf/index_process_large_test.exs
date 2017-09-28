defmodule ContentIndexer.TfIdf.IndexProcessLargeTest do
  use ContentIndexer.Support.LibCase
  alias ContentIndexer.Services.{PreProcess, SearchUtils, Similarity}
  alias ContentIndexer.TfIdf.WeightsIndexer

  setup do
    SearchUtils.build_weight_index("test/fixtures_bench", &PreProcess.pre_process_content/2)
    :ok
  end

  @tag :skipinci
  test "testing the index against a the term monergism" do
    {:ok, documents} = WeightsIndexer.state()
    query_terms = ["monergism"] |> SearchUtils.compile_query(&PreProcess.pre_process_query/1)
    results = Similarity.compare(documents, query_terms)
    assert results == [] # results relate to data not checked into source control
  end

  @tag :skipinci
  test "testing the index against a the term predestination" do
    {:ok, documents} = WeightsIndexer.state()
    query_terms = ["predestination"] |> SearchUtils.compile_query(&PreProcess.pre_process_query/1)
    results = Similarity.compare(documents, query_terms)
    assert results == [] # results relate to data not checked into source control
  end

  @tag :skipinci
  test "testing the index against the term grace" do
    {:ok, documents} = WeightsIndexer.state()
    query_terms = ["grace"] |> SearchUtils.compile_query(&PreProcess.pre_process_query/1)
    results = Similarity.compare(documents, query_terms)
    assert results == [] # results relate to data not checked into source control
  end
end
