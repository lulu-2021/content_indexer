defmodule ContentIndexer.Services.FileUtils do
  @moduledoc """
    some utility functions to read files and extract content
  """

  @stop_words "a,an,and,are,as,at,be,but,by,for,from,if,in,into,is,it,has,had,have,no,not,of,on,or,such,that,the,their,then,there,these,they,this,to,was,will,with"

  def crawl(data_folder) do
    File.ls!(data_folder)
    |> Enum.map(fn(file) ->
      IO.puts "Crawling local file: #{file}"
      content = compile(file, data_folder)
      IO.inspect content
    end)
  end

  def crawl_async(data_folder) do
    File.ls!(data_folder)
    |> Enum.map(fn(file) ->
      Task.async(fn ->
        IO.puts "Crawling local file: #{file}"
        content = compile(file, data_folder)
        IO.inspect content
      end)
    end)
    |> Enum.map(&Task.await/1)
  end

  def compile_query(query_tokens) do
    query_tokens
    |> remove_stop_words()
    |> remove_blanks()
    Enum.to_list(query_tokens)
    |> Stemmer.stem()
  end

  defp compile(file, folder) do
    file_content = Path.join([folder, file])
    |> File.read!
    |> split_content_from_header
    |> remove_non_chars()

    parsed_tokens = file_content
    |> remove_stop_words()
    |> remove_blanks()
    Enum.to_list(parsed_tokens)
    |> Stemmer.stem()
  end

  defp split_content_from_header(data) do
    [frontmatter, text_content] = String.split(data, ~r/\n-{3,}\n/, parts: 2)
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
