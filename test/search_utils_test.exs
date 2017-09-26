defmodule ContentIndexer.Services.SearchUtilsTest do
  use ContentIndexer.Support.LibCase
  alias ContentIndexer.Services.{PreProcess, SearchUtils}

  setup do
    :ok
  end

  test "read a list of query tokens and compile them to be searchable" do
    test_query_tokens = ["this", "is", "a", "test", "query"]
    tokenised_query = SearchUtils.compile_query(test_query_tokens, &PreProcess.pre_process_query/1)

    assert tokenised_query == [{"test", -0.34657359027997264}, {"queri", -0.34657359027997264}]
  end

  test "read the markdown files in the fixtures folder" do
    test_fixture_folder = "test/fixtures"
    token_map = SearchUtils.crawl(test_fixture_folder, &PreProcess.pre_process_content/2)
    processed_tokens = token_map
    |> Enum.map(fn(t) ->
      elem(t, 1)
    end)
    assert Enum.count(SearchUtils.accum_list(processed_tokens)) == 138
  end
end
