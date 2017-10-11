defmodule ContentIndexer.Adapters.InMemoryAdapterTest do
  use ContentIndexer.Support.LibCase

  alias ContentIndexer.Store.InMemoryAdapter

  setup do
    File.rm("corpus_test")
    {:ok, all, _state} = InMemoryAdapter.init(:corpus_test, %{})
    {:ok, value, state} = InMemoryAdapter.put(:corpus_size, 88, :corpus_test, all)
    {:ok, all: all, state: state, value: value}
  end

  test "initialized", %{all: _all, state: state, value: _value} do
    {:ok, value, all} = InMemoryAdapter.get(:corpus_size, :corpus_test, state)
    assert value == 88
    assert all == %{corpus_size: 88}
  end

  test "retrieve the state", %{all: _all, state: state, value: _value} do
    {:ok, response, new_state} = InMemoryAdapter.state(:corpus_test, state)
    assert state == new_state
    assert response == state
  end

  test "added a new key value pair", %{all: all, state: state, value: _value} do
    {:ok, _value, updated_state} = InMemoryAdapter.put(:corpus_test_new, 77, :corpus_test, state)

    assert all == %{}
    assert updated_state == %{corpus_size: 88, corpus_test_new: 77}
  end

  test "reset the state", %{all: _all, state: state, value: _value} do
    {:ok, :reset, new_state} = InMemoryAdapter.reset(:corpus_test, state)
    assert new_state == %{}
  end
end
