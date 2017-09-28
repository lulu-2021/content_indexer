defmodule ContentIndexer.TfIdf.WeightsIndexerTest do
  use ContentIndexer.Support.LibCase
  alias ContentIndexer.TfIdf.WeightsIndexer

  setup do
    WeightsIndexer.reset()
    :ok
  end

  test "weights_index is initially an empty map" do
    {:ok, index} = WeightsIndexer.state()
    assert index == []
  end

  test "reset state to an empty list" do
    {:ok, message} = WeightsIndexer.reset()
    assert message == :reset

    {:ok, index} = WeightsIndexer.state()
    assert index == []
  end

  test "add a doc_index to the state" do
    {:ok, message} = WeightsIndexer.add("test_file_1.md", [{"butter", 3}, {"jam", 2}])
    assert message == :added
    {:ok, new_state} = WeightsIndexer.state()
    assert new_state == [{"test_file_1.md", [{"butter", 3}, {"jam", 2}]}]
  end

  test "add multiple doc_indexes to the state" do
    WeightsIndexer.add("test_file_1.md", [{"butter", 3}, {"jam", 2}])
    WeightsIndexer.add("test_file_2.md", [{"apple", 3}, {"orange", 2}])
    {:ok, new_state} = WeightsIndexer.state()
    assert new_state == [{"test_file_2.md", [{"apple", 3}, {"orange", 2}]}, {"test_file_1.md", [{"butter", 3}, {"jam", 2}]}]
  end
end
