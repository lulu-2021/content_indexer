defmodule ContentIndexer.Adapters.DetsAdapterTest do
  use ContentIndexer.Support.LibCase

  alias ContentIndexer.Store.DetsAdapter

  setup do
    File.rm("corpus_test")
    {:ok, all, _state} = DetsAdapter.init(:corpus_test, %{})
    {:ok, value, state} = DetsAdapter.put(:corpus_size, 88, :corpus_test, all)
    {:ok, all: all, state: state, value: value}
  end

  test "initialized", %{all: _all, state: state, value: _value} do
    {:ok, value, all} = DetsAdapter.get(:corpus_size, :corpus_test, state)
    assert value == 88
    assert all == %{corpus_size: 88}
  end

  test "retrieve the state", %{all: _all, state: state, value: _value} do
    {:ok, response, new_state} = DetsAdapter.state(:corpus_test, state)
    assert state == new_state
    assert response == state
  end

  test "added a new key value pair", %{all: all, state: state, value: _value} do
    DetsAdapter.put(:corpus_test_new, 77, :corpus_test, state)
    {:ok, new_all, new_state} = DetsAdapter.all(:corpus_test, %{})

    assert all == %{}
    assert new_all == %{corpus_size: 88, corpus_test_new: 77}
    assert new_all == new_state
  end

  test "reset the state", %{all: _all, state: state, value: _value} do
    {:ok, :reset, new_state} = DetsAdapter.reset(:corpus_test, state)
    assert new_state == %{}
  end
end
