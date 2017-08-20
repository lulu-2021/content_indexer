defmodule ContentIndexer.Services.ListCheckerWorker do
  @moduledoc """
    genserver based approach to the ListCheckerWorker
    ** Summary **
      ListCheckerWorker is the OTP actor that handles the actual ContentIndexerService.list_contains to check
      whether a given word is contained in a list of tokens

     Due to the fact that we have a very large dataset - potentially millions - a process is spawned for each

   ** Basic Useage **

    A method is called by the server for each list of tokens and returns a result based on whether
    a given word was found in the list or not
  """
  use GenServer

  alias ContentIndexer.Services.Calculator
  alias ContentIndexer.Services.ListCheckerServer

  #-------------------------------------------------------------------#
  # Genserver methods to handle it's message passing
  #-------------------------------------------------------------------#

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:ok, init_worker}
  end

  def handle_call({:list, message}, _from, state) do
    {tokens, index, word} = decode(message)
    if Calculator.list_contains(tokens, word) do
      ListCheckerServer.count("#{index},1")
    else
      ListCheckerServer.count("#{index},0")
    end
    {:reply, {:ok, state}, state}
  end

  #-------------------------------------------------------------------#
  # ListCheckerWorker functions
  #-------------------------------------------------------------------#

  def init_worker do
    IO.puts "\nInitialising ListCheckerWorker\n"
  end

  def list(message) do
    GenServer.call(__MODULE__, {:list, message})
  end

  defp decode(message) do
    [ index | tail ] = String.split(message, ",")
    [ word | tokens ] = tail
    {tokens, index, word}
  end
end
