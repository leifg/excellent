defmodule Monitor do
  use ExFSWatch, dirs: ["./lib", "./spec"]

  def callback(:stop) do
    IO.puts "STOP"
  end

  def callback(file_path, events) do
    if Enum.member?(events, :modified) do
      {:ok, file_path} |> filter |> find_spec |> run_spec
    end
  end

  defp filter({:ok, file_path}) do
    if Regex.match?( ~r/\.(ex|exs|eex)\z/i, file_path ) do
      {:ok, file_path}
    else
      {:ignore, {:no_elixir_file, file_path}}
    end
  end

  defp filter(state) do
    state
  end

  defp find_spec({:ok, file_path}) do
    cond do
      Regex.match?(~r/_spec\.exs$/, file_path) ->
        {:ok, file_path}
      File.exists?(guess_spec_path(file_path)) ->
        {:ok, guess_spec_path(file_path)}
      true ->
        {:ignore, { :no_spec_file_found, file_path } }
    end
  end

  defp find_spec(state) do
    state
  end

  defp run_spec({:ok, file_path}) do
    IO.puts "Running specs for '#{file_path}'"
    Mix.Task.reenable "espec"
    ESpec.start
    Mix.Task.run "espec", [file_path]
    {:ok, file_path}
  end

  defp run_spec(state) do
    state
  end

  defp guess_spec_path(file_path) do
    file_name = Regex.replace(~r/\.exs?$/, file_path, "_spec.exs")
    Regex.replace(~r/\/lib\//, file_name, "/spec/")
  end
end
