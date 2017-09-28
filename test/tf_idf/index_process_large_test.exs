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
    assert results == [
      "2017-09-12-monergism-or-synergism.md",
      "2017-09-14-misunderstanding-election.md"
    ]
  end

  @tag :skipinci
  test "testing the index against a the term predestination" do
    {:ok, documents} = WeightsIndexer.state()
    query_terms = ["predestination"] |> SearchUtils.compile_query(&PreProcess.pre_process_query/1)
    results = Similarity.compare(documents, query_terms)
    assert results == [
      "2017-07-25-does-god-have-choice.md",
      "2017-09-12-monergism-or-synergism.md",
      "2017-09-14-misunderstanding-election.md"
    ]
  end

  test "testing the index against the term grace" do
    {:ok, documents} = WeightsIndexer.state()
    query_terms = ["grace"] |> SearchUtils.compile_query(&PreProcess.pre_process_query/1)
    results = Similarity.compare(documents, query_terms)

    assert results == [
      "2016-10-25-can-the-law-make-a-man-right.md",
      "2016-09-15-savable-or-saved.md",
      "2016-12-26-the-lengths-God-will-go.md",
      "2016-09-20-grace-equals-rest.md",
      "2017-07-27-antinomianism-and-legalism-symptoms-of-same-sickness.md",
      "2016-10-20-made-in-the-image-of-god.md",
      "2016-09-22-no-one-is-right.md",
      "2016-09-20-did-james-teach-a-different-gospel.md",
      "2017-09-12-monergism-or-synergism.md",
      "2016-09-21-what-is-really-important.md",
      "2017-09-09-fate-of-those-who-never-hear.md",
      "2017-05-10-how-to-read-the-bible.md",
      "2017-08-15-missing-verses.md",
      "2016-09-01-wrestling.md",
      "2017-09-14-misunderstanding-election.md"]
  end
end
