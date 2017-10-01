defmodule ContentIndexer.TfIdf.CorpusTest do
  use ContentIndexer.Support.LibCase
  alias ContentIndexer.TfIdf.Corpus

  setup do
    Corpus.reset(0)
    :ok
  end

  test "corpus count is initially zero" do
    {:ok, corpus_count} = Corpus.count()
    assert corpus_count == 0
  end

  test "incrementing the corpus count" do
    assert Corpus.increment == {:ok, :incremented}
    assert Corpus.increment == {:ok, :incremented}
    assert Corpus.count == {:ok, 2}
  end

  test "decrementing the corpus count" do
    assert Corpus.increment == {:ok, :incremented}
    assert Corpus.increment == {:ok, :incremented}
    assert Corpus.increment == {:ok, :incremented}
    assert Corpus.decrement == {:ok, :decremented}
    assert Corpus.count == {:ok, 2}
  end
end
