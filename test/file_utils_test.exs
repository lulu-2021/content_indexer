defmodule ContentIndexer.Services.FileUtilsTest do
  use ContentIndexer.Support.LibCase
  alias ContentIndexer.Services.FileUtils

  setup do
    :ok
  end

  test "read the markdown files in the fixtures folder" do
    test_fixture_folder = "test/fixtures"
    processed_tokens = FileUtils.crawl(test_fixture_folder)
    assert processed_tokens == [["test1", "this", "test", "file", "one", "two", "simpl", "line", "text"],
    ["test2", "cook", "great", "hobbi"],
    ["test3", "how", "about", "learn", "new", "music", "instrument", "year"]]
  end
end
