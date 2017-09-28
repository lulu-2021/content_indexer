defmodule ContentIndexer.TfIdf.DocCountsTest do
  use ContentIndexer.Support.LibCase
  alias ContentIndexer.TfIdf.DocCounts

  setup do
    DocCounts.reset
    :ok
  end

  test "doc_counts is initially an empty list" do
    {:ok, doc_counts} = DocCounts.state
    assert doc_counts == %{}
  end

  test "reset state to an empty list" do
    {:ok, message} = DocCounts.reset
    assert message == :reset

    {:ok, doc_counts} = DocCounts.state
    assert doc_counts == %{}
  end

  test "retrieve a document term count" do
    document_name = "test_file_1.md"
    term_count = 34
    {:ok, doc_count} = DocCounts.add_document(document_name, term_count)
    assert doc_count == {document_name, term_count}

    assert DocCounts.document_term_count(document_name) == {:ok, {"test_file_1.md", 34}}
  end

  test "add a document term count" do
    document_name = "test_file_1.md"
    term_count = 34
    {:ok, doc_count} = DocCounts.add_document(document_name, term_count)
    assert doc_count == {document_name, term_count}

    assert DocCounts.state() == {:ok, %{"test_file_1.md" => 34}}
  end

  test "updates a document term count" do
    document_name = "test_file_1.md"
    term_count = 34
    DocCounts.add_document(document_name, term_count)
    document_name = "test_file_1.md"
    updated_term_count = 96
    {:ok, updated_doc_count} = DocCounts.add_document(document_name, updated_term_count)

    assert updated_doc_count == {document_name, updated_term_count}

    assert DocCounts.state() == {:ok, %{"test_file_1.md" => 96}}
  end

  test "add multiple document term counts" do
    DocCounts.add_document("test_file_1.md", 33)
    DocCounts.add_document("test_file_2.md", 34)
    DocCounts.add_document("test_file_3.md", 35)

    assert DocCounts.state() == {:ok, %{"test_file_1.md" => 33, "test_file_2.md" => 34, "test_file_3.md" => 35}}
  end

end
