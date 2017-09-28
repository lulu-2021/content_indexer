defmodule ContentIndexer.Services.PreProcessTest do
  use ContentIndexer.Support.LibCase
  alias ContentIndexer.Services.PreProcess

  setup do
    :ok
  end

  test "process a list of query terms" do
    query_terms = ["This", "Is", "a", "simulation", "praising"]
    processed_query = PreProcess.pre_process_query(query_terms)
    assert processed_query == ["simul", "prais"]
  end
end
