defmodule ContentIndexer.Index do
  @moduledoc """
    struct to store the details of what data is held in the index
    It provides a `new/2` function for instantiating the struct that includes a generated UUID
  """
  alias Ecto.UUID
  alias ContentIndexer.Index

  defstruct uuid: "", file_name: "", tokens: [], term_weights: %{}

  @doc """
    Instantiates a new Index struct

    ## Parameters

      - file_name: String that represents the file that has the content to be indexed
      - tokens: List of Strings that are the tokenised content

    ## Example

      iex> ContentIndexer.Index.new("test_file.md", ["bread", "butter", "jam", "mustard"])
      %ContentIndexer.Index{file_name: "test_file.md", term_weights: %{}, tokens: ["bread", "butter", "jam", "mustard"], uuid: "e080d012-f89b-434c-964f-ddad9b8c2e20"}
  """
  def new(file_name, tokens) when is_list(tokens) do
    new_uuid = UUID.generate()
    %Index{file_name: file_name, tokens: tokens, uuid: new_uuid}
  end

end
