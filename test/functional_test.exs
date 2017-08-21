defmodule ContentIndexer.Services.FunctionalTest do
  use ContentIndexer.Support.LibCase

  alias ContentIndexer.Services.{Calculator}

  test "read test fixtures" do
    test_files = read_fixture_content("test/fixtures")

    tokens_file_1 = test_files["test1.md"] |> test_tokens()
    tokens_file_2 = test_files["test2.md"] |> test_tokens()
    tokens_file_3 = test_files["test3.md"] |> test_tokens()

    corpus_of_tokens = [tokens_file_1, tokens_file_2, tokens_file_3]
    {:ok, token_content_indexers} = Calculator.calculate_tokens_againts_corpus(tokens_file_3, corpus_of_tokens)

    IO.inspect token_content_indexers
  end

  def read_fixture_content(fixture_folder) do
    file_list = File.ls!(fixture_folder)
    |> Enum.reduce(%{}, fn(file, acc) ->
      Dict.put(acc, file, read_file(file, fixture_folder))
    end)
  end

  # just a simplistic process to extract the fixture text for this test..
  def read_file(file, folder) do
    Path.join([folder, file])
    |> File.read!
    |> String.replace(~r/\n/, "")
    |> String.replace(~r/##/, "")
    |> String.split(" ")
    |> Enum.drop_while(fn(w) -> w == "" end)
  end

  defp test_tokens(indata) do
    indata
    |> Enum.map(fn(token) -> "#{token}," end)
    |> Enum.drop(-1)
    |> to_string
    |> String.strip(?, )
  end
end
