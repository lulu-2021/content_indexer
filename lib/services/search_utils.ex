defmodule ContentIndexer.Services.SearchUtils do
  @moduledoc """
    some utility functions to read files and extract content
  """
  alias ContentIndexer.Services.{Calculator, Indexer}

  def crawl(data_folder, file_pre_process_func) do
    File.ls!(data_folder)
    |> Enum.map(fn(file) ->
      compile(file, data_folder, file_pre_process_func)
    end)
  end

  def crawl_async(data_folder, file_pre_process_func) do
    File.ls!(data_folder)
    |> Enum.map(fn(file) ->
      Task.async(fn ->
        compile(file, data_folder, file_pre_process_func)
      end)
    end)
    |> Enum.map(&Task.await/1)
  end

  def compile_query(query, query_pre_process_func) do
    #query_tokens = query
    #|> remove_stop_words()
    #|> remove_blanks()
    #stemmed_query = Enum.to_list(query_tokens)
    stemmed_query = query_pre_process_func.(query)
    |> Stemmer.stem()
    {:ok, query} = Calculator.calculate_content_indexer_documents(stemmed_query, [stemmed_query])
    query
  end

  def accum_list([]), do: []
  def accum_list([h | t]), do: accum_list([h | t], [])
  def accum_list([h | t], acc) when is_list(h), do: accum_list(t, accum_list(h, acc))
  def accum_list([h | t], acc), do: accum_list(t, acc ++ [h])
  def accum_list([], acc), do: acc

  def build_index(data_folder, file_pre_process_func) do
    data_folder
    |> crawl(file_pre_process_func)
    |> Enum.each(fn(t) ->
      Indexer.add(elem(t, 0), elem(t, 1))
    end)
  end

  defp compile(file, folder, file_pre_process_func) do
    file_name = Path.join([folder, file])
    file_content = file_name
    |> File.read!
    stemmed_tokens = file_content
    |> file_pre_process_func.(file_name)
    #|> remove_non_chars()
    #|> remove_stop_words()
    #|> remove_blanks()
    #stemmed_tokens = parsed_tokens
    #|> Enum.to_list()
    |> Stemmer.stem()
    # return a tuple of the filename and finalised tokens
    {file, stemmed_tokens}
  end
end
