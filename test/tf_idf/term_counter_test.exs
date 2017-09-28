defmodule ContentIndexer.TfIdf.TermCounterTest do
  use ContentIndexer.Support.LibCase
  alias ContentIndexer.{Services.PreProcess, TfIdf.TermCounter}

  test "checking file tokens" do
    tokens = compile_test_file("test1.md", "test/fixtures", &PreProcess.pre_process_content/2)
    matrix = TermCounter.unique_term_count(tokens)

    assert matrix == [{"advantag", 1}, {"ani", 1}, {"annoy", 1}, {"avoid", 1}, {"choos", 1}, {"consequ", 1}, {"enjoy", 1}, {"ever", 1}, {"exampl", 1}, {"except", 1}, {"exercis", 1}, {"fault", 1}, {"file", 1}, {"find", 1}, {"labori", 1}, {"line", 1}, {"man", 1}, {"obtain", 1}, {"one", 2}, {"pain", 1}, {"physic", 1}, {"pleasur", 3}, {"produc", 1}, {"result", 1}, {"right", 1}, {"simpl", 1}, {"some", 1}, {"take", 1}, {"test", 2}, {"text", 1}, {"three", 1}, {"trivial", 1}, {"two", 1}, {"undertak", 1}, {"us", 1}, {"which", 1}, {"who", 3}]
  end

  defp compile_test_file(file, folder, file_pre_process_func) do
    file_name = Path.join([folder, file])
    file_name
    |> File.read!
    |> file_pre_process_func.(file_name)
  end
end
