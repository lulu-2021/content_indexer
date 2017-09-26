defmodule ContentIndexer.Services.SearchUtils do
  @moduledoc """
    some utility functions to read files and extract content
  """
  alias ContentIndexer.Services.{Calculator, Indexer}

  @stop_words "a,an,and,are,as,at,be,but,by,for,from,if,in,into,is,it,has,had,have,no,not,of,on,or,such,that,the,their,then,there,these,they,this,to,was,will,with"

  def crawl(data_folder) do
    File.ls!(data_folder)
    |> Enum.map(fn(file) ->
      # IO.puts "Crawling local file: #{file}"
      compile(file, data_folder)
    end)
  end

  def crawl_async(data_folder) do
    File.ls!(data_folder)
    |> Enum.map(fn(file) ->
      Task.async(fn ->
        # IO.puts "Crawling local file: #{file}"
        compile(file, data_folder)
      end)
    end)
    |> Enum.map(&Task.await/1)
  end

  def compile_query(query) do
    query_tokens = query
    |> remove_stop_words()
    |> remove_blanks()
    stemmed_query = Enum.to_list(query_tokens)
    |> Stemmer.stem()
    {:ok, query} = Calculator.calculate_content_indexer_documents(stemmed_query, [stemmed_query])
    query
  end

  def accum_list([]), do: []
  def accum_list([h | t]), do: accum_list([h | t], [])
  def accum_list([h | t], acc) when is_list(h), do: accum_list(t, accum_list(h, acc))
  def accum_list([h | t], acc), do: accum_list(t, acc ++ [h])
  def accum_list([], acc), do: acc

  def build_index(data_folder) do
    data_folder
    |> crawl()
    |> Enum.each(fn(t) ->
      Indexer.add(elem(t, 0), elem(t, 1))
    end)
  end

  defp compile(file, folder) do
    file_content = Path.join([folder, file])
    |> File.read!

    parsed_tokens = file_content
    |> split_content_from_header
    |> remove_non_chars()
    |> remove_stop_words()
    |> remove_blanks()
    stemmed_tokens = parsed_tokens
    |> Enum.to_list()
    |> Stemmer.stem()
    # return a tuple of the filename and finalised tokens
    {file, stemmed_tokens}
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
