defmodule ContentIndexer.TfIdf.TermCountsTest do
  use ContentIndexer.Support.LibCase
  alias ContentIndexer.TfIdf.TermCounts

  setup do
    TermCounts.reset
    :ok
  end

  test "term_counts is initially an empty list" do
    {:ok, term_counts} = TermCounts.state
    assert term_counts == %{}
  end

  test "reset state to an empty list" do
    {:ok, message} = TermCounts.reset
    assert message == :reset

    {:ok, term_counts} = TermCounts.state
    assert term_counts == %{}
  end

  test "adds a new term to the list" do
    term = "bread"
    {:ok, term_count} = TermCounts.increment_term(term)
    assert term_count == {term, 1}
  end

  test "adds a multiple terms to the list" do
    term = "bread"
    {:ok, term_count} = TermCounts.increment_term(term)
    assert term_count == {term, 1}

    term = "butter"
    {:ok, term_count} = TermCounts.increment_term(term)
    assert term_count == {term, 1}

    term = "butter"
    {:ok, term_count} = TermCounts.increment_term(term)
    assert term_count == {term, 2}

    term = "jam"
    {:ok, term_count} = TermCounts.increment_term(term)
    assert term_count == {term, 1}

    {:ok, term_counts} = TermCounts.state
    assert term_counts == %{"bread" => 1, "butter" => 2, "jam" => 1}
  end

  test "increments count of an existing term in the list" do
    term = "bread"
    {:ok, term_count} = TermCounts.increment_term(term)
    assert term_count == {term, 1}

    term = "bread"
    {:ok, new_term_count} = TermCounts.increment_term(term)
    assert new_term_count == {term, 2}

    term = "bread"
    {:ok, new_term_count} = TermCounts.increment_term(term)
    assert new_term_count == {term, 3}
  end
end
