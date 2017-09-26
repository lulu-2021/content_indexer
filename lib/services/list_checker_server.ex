defmodule ContentIndexer.Services.ListCheckerServer do
  @moduledoc """
    ** Summary **
      ListCheckerServer is the OTP server that uses Genserver to handle the
      interactions with the individual workers and the parent caller
      The ListCheckerWorkers each process a list of tokens
      and checks that list for a given token. Once it is done a message is
      returned to the ListCheckerServer.
      The server in turn sends a message to the callee - advising it once the whole
      list of token lists has been checked successfully!

   ** Basic Useage **

   The start method is called by a calling parent as well as the start_worker to spawn parallel processing
    of a large number of token lists

   We pass it the size of the list of tokens for a running total and the PID of the calling parent process
    to whom we pass the completed result back once done
  """
  use GenServer

  #-------------------------------------------------------------------#
  # Genserver methods to handle it's message passing
  #-------------------------------------------------------------------#

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def init(:ok) do
    {:ok, init_server()}
  end

  def handle_call({:initialise_collection, collection_size, parent_pid}, _from, _cstate) do
    state = {0, 1, collection_size, parent_pid}
    {:reply, {:ok, state}, state}
  end

  def handle_call({:state}, _from, state) do
    {:reply, {:ok, state}, state}
  end

  def handle_call({:count, _index, count}, _from, state) do
    {total, list_counter, list_size, parent_pid} = state
    state = if list_counter == list_size do
      send(parent_pid, {:total, total + count})
      state
    else
      {total + count, list_counter + 1, list_size, parent_pid}
    end
    {:reply, {:ok, state}, state}
  end

  #-------------------------------------------------------------------#
  # ListCheckerServer functions
  #-------------------------------------------------------------------#

  def current_state do
    GenServer.call(__MODULE__, {:state})
  end

  def init_server do
    IO.puts "\nInitialising ListCheckerServer\n"
  end

  def initialise_collection(list_size, parent_pid) do
    GenServer.call(__MODULE__, {:initialise_collection, list_size, parent_pid})
  end

  def count(index, count) do
    GenServer.call(__MODULE__, {:count, index, count})
  end
end
