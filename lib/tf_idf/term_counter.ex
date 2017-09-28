defmodule ContentIndexer.TfIdf.TermCounter do
  @moduledoc """
    small module to group and count the number of token occurrences in
    a list of tokens
  """

  # given a list of string tokens - this will return a list of tuples
  # with each tuple containing unique terms & counts in the tokens list
  def unique_term_count(tokens) when is_list(tokens) do
    tokens_stream = tokens
    |> Enum.sort()
    |> Stream.chunk_by(fn arg -> arg end)
    |> Stream.map(fn(x) ->
      {List.first(x), Enum.count(x)}
    end)
    Enum.to_list(tokens_stream)
  end

end
