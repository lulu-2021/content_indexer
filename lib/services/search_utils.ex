defmodule ContentIndexer.Services.SearchUtils do
  @moduledoc """
    utility functions to crawl a folder with files and extract content - the actual processing of the content is handled
    by the file_pre_process_func function that we are using from the ContentIndexer.Services.PreProcess module - however
    this can easily be swapped out by passing your own pre-process
  """
  alias ContentIndexer.{Index, Indexer, IndexInitialiser, Services.Calculator}

  @doc """
    crawls a folder and process the content into tokens using the passed in function
    See the `ContentIndexer.Services.PreProcess` module for what sort of pre-processing is done when the content is crawled

    ## Parameters

      - data_folder: String - folder name
      - file_pre_process_func: Function with 2 parameters that is used to pre-process the token data

    ## Example

      iex> ContentIndexer.Services.SearchUtils.crawl("test/fixtures", &ContentIndexer.Services.PreProcess.pre_process_content/2)
            [
              {"test1.md",
                ["test1", "this", "test", "file", "one", "two", "simpl", "line", "text"...]},
              {"test2.md",
                ["test2", "cook", "great", "hobbi", "nor", "again", "anyon", "who", "love"...]},
              {"test3.md",
                ["test3", "how", "about", "learn", "new", "music", "instrument", "year"...]}
            ]
  """
  def crawl(data_folder, file_pre_process_func) do
    files = File.ls!(data_folder)
    files
    |> Enum.map(fn(file) ->
      compile(file, data_folder, file_pre_process_func)
    end)
  end

  @doc """
    see crawl function - this version does the same thing - just in the background using a Task.
  """
  def crawl_async(data_folder, file_pre_process_func) do
    files = File.ls!(data_folder)
    files
    |> Enum.map(fn(file) ->
      Task.async(fn ->
        compile(file, data_folder, file_pre_process_func)
      end)
    end)
    |> Enum.map(&Task.await/1)
  end

  @doc """
    Compiles the query using the passed pre-process function
    See the `ContentIndexer.Services.PreProcess` module for what sort of pre-processing is done to the query tokens list

    ## Parameters

      - query: List of String query tokens
      - file_pre_process_func: Function with 1 parameter that is used to pre-process the token data

    ## Example

      iex> ContentIndexer.Services.SearchUtils.compile_query(["bread", "and", "butter"], &ContentIndexer.Services.PreProcess.pre_process_query/)
            [{"bread", -0.34657359027997264}, {"butter", -0.34657359027997264}]
  """
  def compile_query(query, query_pre_process_func) do
    processed_query = query_pre_process_func.(query)
    stemmed_query = processed_query
    |> Stemmer.stem()
    {:ok, query} = Calculator.calculate_content_indexer_documents(stemmed_query, [stemmed_query])
    query
  end

  def build_index(data_folder, file_pre_process_func) do
    data_folder
    |> crawl(file_pre_process_func)
    |> Enum.each(fn(t) ->
      Indexer.add(elem(t, 0), elem(t, 1))
    end)
  end

  def build_index_data(data_folder, file_pre_process_func) do
    index = data_folder
    |> crawl(file_pre_process_func)
    |> Enum.map(fn(t) ->
        Index.new(elem(t, 0), elem(t, 1))
    end)
    Task.async(fn -> IndexInitialiser.initialise_index(index) end)
    |> Task.await
  end

  def accum_list([]), do: []
  def accum_list([h | t]), do: accum_list([h | t], [])
  def accum_list([h | t], acc) when is_list(h), do: accum_list(t, accum_list(h, acc))
  def accum_list([h | t], acc), do: accum_list(t, acc ++ [h])
  def accum_list([], acc), do: acc

  defp compile(file, folder, file_pre_process_func) do
    file_name = Path.join([folder, file])
    file_content = file_name
    |> File.read!
    stemmed_tokens = file_content
    |> file_pre_process_func.(file_name)
    |> Stemmer.stem()
    # return a tuple of the filename and finalised tokens
    {file, stemmed_tokens}
  end
end
