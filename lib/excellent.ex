defmodule Excellent do
  require Record

  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  def read filename, num_of_worksheet do
    xml_content = file_content(filename, 'xl/worksheets/sheet#{num_of_worksheet + 1}.xml')

    {:ok, res, _} = :xmerl_sax_parser.stream(xml_content, event_fun: &event/3, event_state: %{shared_strings: shared_strings(filename), lookup: false, content: []})
    res[:content]
  end

  def worksheet_names filename do
    {xml, _rest} = :xmerl_scan.string(:erlang.binary_to_list(file_content(filename, 'xl/workbook.xml')))
    :xmerl_xpath.string('/workbook/sheets/sheet/@name', xml) |> Enum.map(fn(x) -> :erlang.list_to_binary(xmlAttribute(x, :value)) end) |> List.to_tuple
  end

  def shared_strings(spreadsheet_filename) do
    shared_strings_to_tuple(file_content(spreadsheet_filename, 'xl/sharedStrings.xml'))
  end

  def shared_strings_to_tuple(shared_strings) do
    {xml, _rest} = :xmerl_scan.string(:erlang.binary_to_list(shared_strings))
    :xmerl_xpath.string('/sst/si/t/text()', xml) |> Enum.map(fn(si) -> to_string(xmlText(si, :value)) end) |> List.to_tuple
  end

  defp file_content(spreadsheet_filename, inner_filename) do
    {:ok, [{_filename, file_content}]} = :zip.extract spreadsheet_filename, [:memory, {:file_filter, fn(file) -> elem(file, 1) == inner_filename end }]
    file_content
  end

  defp event({:startElement, _, 'row', _, _}, _, state) do
    Dict.put(state, :current_row, [])
  end

  defp event({:startElement, _, 'c', _, [_, _, {_, _, 't', 's'}]}, _, state) do
    Dict.put(state, :lookup, true)
  end

  defp event({:endElement, _, 'c', _}, _, state) do
    Dict.put(state, :lookup, false)
  end

  defp event({:startElement, _, 'v', _, _}, _, state) do
    Dict.put(state, :collect, true)
  end

  defp event({:endElement, _, 'v', _}, _, state) do
    Dict.put(state, :collect, false)
  end

  defp event({:characters, chars}, _, %{ collect: true, lookup: true } = state) do
    {line, _} = chars |> :erlang.list_to_binary |> Integer.parse
    line = elem(state[:shared_strings], line)

    Dict.put(state, :current_row, List.insert_at(state[:current_row],-1, line))
  end

  defp event({:characters, chars}, _, %{ collect: true, lookup: false } = state) do
    Dict.put(state, :current_row, List.insert_at(state[:current_row],-1, chars |> :erlang.list_to_binary))
  end

  defp event({:endElement, _, 'row', _}, _, state) do
    Dict.put(state, :content, List.insert_at(state[:content],-1, state[:current_row]))
  end

  defp event(_, _, state) do
    state
  end
end
