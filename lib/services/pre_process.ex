defmodule ContentIndexer.Services.PreProcess do
  @moduledoc """
    content and query pre-process functions that are passed to the SearchUtils.compile and SearchUtils.compile_query functions - here we are just some some extra stuf
    with a markdown file - i.e. removing the header.

    The import thing to note is that these two functions take in the content as a string and spit out a list of tokenized strings.

    The steps we are taking:

    (1) Remove all the stop words - they are noise and we should never search by them
    (2) remove non-char data & white space

    Using streams means most of the work will happen in a single step
  """

  @stop_words "a,an,and,are,as,at,be,but,by,for,from,if,in,into,is,it,has,had,have,no,not,of,on,or,such,that,the,their,then,there,these,they,this,to,was,will,with"

  def pre_process_query(query) do
    query_tokens = query
    |> remove_stop_words()
    |> remove_blanks()
    Enum.to_list(query_tokens)
  end

  def pre_process_content(content, file_name) do
    token_content = case Path.extname(file_name) do
      ".md" -> split_content_from_header(content)
      _ -> content
    end
    token_content
    |> remove_non_chars()
    |> remove_stop_words()
    |> remove_blanks()
    |> Enum.to_list()
  end

  defp split_content_from_header(data) do
    [_frontmatter, text_content] = String.split(data, ~r/\n-{3,}\n/, parts: 2)
    text_content
  end

  defp remove_stop_words(tokens) do
    stop_words = String.split(@stop_words, ",")
    tokens
    |> Stream.reject(fn(token) ->
      Enum.find(stop_words, fn(word) -> word == token end)
    end)
  end

  defp remove_non_chars(raw_content) do
    raw_content
    |> String.replace(~r/\W/, ",")
    |> String.split(",")
  end

  defp remove_blanks(tokens) do
    tokens
    |> Stream.filter(fn(s) -> s != "" end)
  end
end
