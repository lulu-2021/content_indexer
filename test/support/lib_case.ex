defmodule ContentIndexer.Support.LibCase do
  @moduledoc """
    This module defines the test case to be used by
    lib unit tests that don't need any dependencies
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with lib - none for now
    end
  end
end
