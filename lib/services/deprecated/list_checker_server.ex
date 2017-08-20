defmodule ContentIndexer.Services.Deprecated.ListCheckerServer do
  @moduledoc """
    ** Summary **
      ListCheckerServer is the OTP server that spawns a worker (ListCheckerWorker) for each list of tokens
      and sends it a message asking it to check that list for a given token. Once it is done a message is
      returned to the server. The server in turn sends a message to the callee - advising it once the whole
      list of token lists has been checked successfully!

   ** Basic Useage **

   The start method is called by a calling parent as well as the start_worker to spawn parallel processing
    of a large number of token lists

   We pass it the size of the list of tokens for a running total and the PID of the calling parent process
    to whom we pass the completed result back once done

   iex> ListCheckerServer.start(list_size, parent_pid)
  """

 alias ContentIndexer.Services.ListCheckerWorker

 @debug_iterations 0

 @doc """
    calls the server_run method which loops waiting for a incoming messages with token list check results

   We pass it the size of the list of tokens for a running total and the PID of the calling parent process
    to whom we pass the completed result back once done

   iex> ListCheckerServer.start(list_size, parent_pid)
  """
  def start(list_size, parent_pid) do
    pid  = spawn(__MODULE__, :server_run, [0, 1, list_size, parent_pid])
    pid
  end

 @doc """
    called by the start method - basically loops waiting for incoming worker results from the ListCheckerWorker
    modules. The results are accumulated and returned to the calling process once all token lists have been checked

   the total is initially zero and the counter is one for the first loop. list_size represents the size of the list
    of tokens being worked on and the parent_pid is the PID of the calling process to whom we return the result

   iex> ListCheckerWorker.server_run(total, list_counter, list_size, parent_pid)
  """
  def server_run(total, list_counter, list_size, parent_pid) do
    receive do
      {:count, message} ->
        {index, count} = decode(message)
        if list_counter < @debug_iterations, do: debug_server_incoming(index, list_counter, count, total)
        if list_counter == list_size do
          send(parent_pid, {:total, total + count})
        else
          server_run(total + count, list_counter + 1, list_size, parent_pid)
        end

     {:test, message} ->
        IO.puts "Test list_checker_server: #{message}"
    end
  end

 defp decode(message) do
    [ index | count ] = String.split(message, ",")
    first = List.first(count)
    counter = first |> String.to_integer
    list_index = String.to_integer(index)
    {list_index, counter}
  end

 defp debug_server_incoming(index, list_counter, count, total) do
    IO.puts "\n\nIndex: #{index}, List Counter: #{list_counter},\n CountWords: #{count}, total:#{total}\n\n"
  end

 defp debug_worker_start(list_index, word, tokens) do
    IO.puts "\n\nstarting worker index: #{list_index}, word: #{word}, tokens: #{tokens}"
  end
end
