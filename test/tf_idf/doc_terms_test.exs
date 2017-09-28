defmodule ContentIndexer.TfIdf.DocTermsTest do
  use ContentIndexer.Support.LibCase
  alias ContentIndexer.TfIdf.DocTerms

  setup do
    DocTerms.reset
    :ok
  end

  test "doc_terms is initially an empty list" do
    {:ok, doc_terms} = DocTerms.state
    assert doc_terms == %{}
  end

  test "reset state to an empty list" do
    {:ok, message} = DocTerms.reset
    assert message == :reset

    {:ok, doc_terms} = DocTerms.state
    assert doc_terms == %{}
  end

  test "add document term counts" do
    DocTerms.add_doc_term_count("test_file.md", "bread", 3)
    DocTerms.add_doc_term_count("test_file.md", "butter", 4)
    DocTerms.add_doc_term_count("test_file.md", "potato", 1)
    {:ok, state} = DocTerms.state()
    assert state == %{"test_file.md___bread" => 3, "test_file.md___butter" => 4,
    "test_file.md___potato" => 1}
  end
end
