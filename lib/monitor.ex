defmodule Monitor do
  use ExFSWatch, dirs: ["./lib", "./spec"]

  def callback(:stop) do
    IO.puts "STOP"
  end

  def callback(file_path, events) do
    filter(file_path) |> eval_spec |> run_spec
  end

  defp eval_spec({:ok, file_path}) do
    if Regex.match?(~r/_spec\.exs$/, file_path) do
      {:ok, file_path}
    else
      find_spec(file_path)
    end
  end

  defp eval_spec(state) do
    state
  end

  defp filter(file_path) do
    if Regex.match?( ~r/\.(ex|exs|eex)\z/i, file_path ) do
      {:ok, file_path}
    else
      {:error, {:eexist, file_path}}
    end
  end

  defp find_spec(file_path) do
    file_name = Regex.replace(~r/\.exs?$/, file_path, "_spec.exs")
    modified_file_path = Regex.replace(~r/\/lib\//, file_name, "/spec/")
    if File.exists?(modified_file_path) do
      {:ok, modified_file_path}
    else
      {:error, {:enoent, file_path}}
    end
  end

  defp run_spec({:ok, file_path}) do
    IO.puts "Running specs for '#{file_path}'"
    Mix.Task.reenable "espec"
    Mix.Task.run "espec", [file_path]
  end

  defp run_spec({:error, {:enoent, file_path}}) do
    IO.puts "no spec file found for '#{file_path}'"
  end

  defp run_spec({:error, {:eexist, _file_path}}) do
  end #nothig
end
