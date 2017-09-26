defmodule ContentIndexer.Services.SimilarityTest do
  use ContentIndexer.Support.LibCase

  alias ContentIndexer.Services.Similarity
  alias ContentIndexer.Services.Calculator

  # from
  # Document 1: The game of life is a game of everlasting learning
  # Document 2: The unexamined life is not worth living
  # Document 3: Never stop learning

  @document_list [
    {"10", %{"life" => 0.140550715, "learning" => 0.140550715}},
    {"3", %{"life" => 0.200786736, "learning" => 0.0        }},
    {"5", %{"life" => 0.0        , "learning" => 0.468502384}},
  ]
  @query_terms ["life", "learning"]
  @expected_result %{ "10" => 1, "3" => 0.7071067811865475, "5" => 0.7071067811865476 }

  test "returns an list ordered by cosine similarity" do
    {_, query} = Calculator.calculate_content_indexer_documents(@query_terms, [@query_terms], 1)

    result = Similarity.get_similarity(@document_list, query)
    assert result == @expected_result
  end

  @query_terms ["life", "learning", "test", "the"]

  @expected_result %{ "10" => 0.7071067811865476, "3" => 0.5, "5" => 0.5 }
  test "more query terms than document terms" do
    {_, query} = Calculator.calculate_content_indexer_documents(@query_terms, [@query_terms], 1)
    result = Similarity.get_similarity(@document_list, query)
    assert result == @expected_result
  end

  @document_list [
    {2, %{"hey"  => 0.200786736, "learning" => 0.0        }},
    {1, %{"life" => 0.140550715, "learning" => 0.140550715}},
    {3, %{"what" => 0.0        , "learning" => 0.468502384}},
  ]
  @query_terms ["life"]
  @expected_result %{2 => 0.0, 1 => 1.0,  3 => 0.0}
  test "more document terms than query terms" do

    {_, query} = Calculator.calculate_content_indexer_documents(@query_terms, [@query_terms], 1)
    result = Similarity.get_similarity(@document_list, query)
    assert result == @expected_result
  end
end

