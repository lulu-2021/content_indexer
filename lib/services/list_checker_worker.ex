defmodule ContentIndexer.Services.ListCheckerWorker do
  @moduledoc """
    ** Summary **
      ListCheckerWorker is the OTP actor that handles the actual ContentIndexerService.list_contains to check
      whether a given word is contained in a list of tokens

     Due to the fact that we have a very large dataset - potentially millions - a process is spawned for each

   ** Basic Useage **

     The listener method is called by the server for each list of tokens and returns a result based on whether
      a given word was found in the list or not

   iex> ListCheckerWorker.start
  """

 alias ContentIndexer.Services.Calculator

 @debug_iterations 0

 @doc """
    calls the listener method which loops waiting for an incoming request to check a token list

   iex> ListCheckerWorker.start
  """
  def start do
    spawn(__MODULE__, :listener,[])
  end

 @doc """
    listener - is called by the start method and returns once the list has been traversed, if a
    message comes requesting a token list contains check

   iex> ListCheckerWorker.listener
    {:count, "1,1"}
  """
  def listener do
    receive do
      {:list, message, server_pid} ->
        {tokens, index, word} = decode(message)
        if String.to_integer(index) < @debug_iterations, do: debug_listener_incoming(tokens, index, word)
        if Calculator.list_contains(tokens, word) do
          send(server_pid, {:count, "#{index},1"})
        else
          send(server_pid, {:count, "#{index},0"})
        end

     {:test, message} ->
        IO.puts "Test list_checker_worker: #{message}"
    end
  end

 defp decode(message) do
    [ index | tail ] = String.split(message, ",")
    [ word | tokens ] = tail
    {tokens, index, word}
  end

 defp debug_listener_incoming(tokens, index, word) do
    IO.puts "\n\nChecker - tokens:"
    IO.puts inspect(tokens)
    IO.puts "Index: #{index}, Word: #{word}\n\n"
  end
end
