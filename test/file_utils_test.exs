defmodule ContentIndexer.Services.FileUtilsTest do
  use ContentIndexer.Support.LibCase
  alias ContentIndexer.Services.FileUtils

  setup do
    :ok
  end

  test "read the markdown files in the fixtures folder" do
    test_fixture_folder = "test/fixtures"
    FileUtils.crawl(test_fixture_folder)

  end
end
