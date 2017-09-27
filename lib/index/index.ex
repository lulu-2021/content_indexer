defmodule ContentIndexer.Index do
  @moduledoc """
    struct to store the details of what data is held in the index
    It provides a `new/2` function for instantiating the struct that includes a generated UUID
  """
  alias Ecto.UUID
  alias ContentIndexer.Index

  defstruct uuid: "", file_name: "", tokens: [], term_weights: %{}

  @doc """

  """
  def new(file_name, tokens) when is_list(tokens) do
    new_uuid = UUID.generate()
    %Index{file_name: file_name, tokens: tokens, uuid: new_uuid}
  end

end
