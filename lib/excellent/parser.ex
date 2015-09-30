defmodule Excellent.Parser do
  require Record

  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  @shared_string_type 's'
  @number_type 'n'
  @boolean_type 'b'

  @true_value '1'
  @false_value '0'

  def sax_parse_worksheet(xml_content, shared_strings, styles) do
    {:ok, res, _} = :xmerl_sax_parser.stream(
      xml_content,
      event_fun: &event/3,
      event_state: %{
        shared_strings: shared_strings,
        styles: styles,
        content: []
      }
    )
    Enum.reverse(res[:content])
  end

  def parse_worksheet_names(xml_content) do
    {xml, _rest} = :xmerl_scan.string(:erlang.binary_to_list(xml_content))
    :xmerl_xpath.string('/workbook/sheets/sheet/@name', xml)
      |> Enum.map(fn(x) -> :erlang.list_to_binary(xmlAttribute(x, :value)) end)
      |> List.to_tuple
  end

  def parse_shared_strings(xml_content) do
    {xml, _rest} = :xmerl_scan.string(:erlang.binary_to_list(xml_content))
    :xmerl_xpath.string('/sst/si/t', xml)
      |> Enum.map(fn(element) -> xmlElement(element, :content) end)
      |> Enum.map(fn(texts) -> Enum.map(texts, fn(text) -> to_string(xmlText(text, :value)) end) |> Enum.join end)
      |> List.to_tuple
  end

  def parse_styles(xml_content) do
    {xml, _rest} = :xmerl_scan.string(:erlang.binary_to_list(xml_content))
    lookup = :xmerl_xpath.string('/styleSheet/numFmts/numFmt', xml)
      |> Enum.map(fn(numFmt) -> { extract_attribute(numFmt, 'numFmtId'), extract_attribute(numFmt, 'formatCode') } end)
      |> Enum.into(%{})

    :xmerl_xpath.string('/styleSheet/cellXfs/xf/@numFmtId', xml)
      |> Enum.map(fn(numFmtId) -> to_string(xmlAttribute(numFmtId, :value)) end)
      |> Enum.map(fn(numFmtId) -> lookup[numFmtId] end)
      |> List.to_tuple
  end

  defp extract_attribute(node, attr_name) do
    [ret | _] = :xmerl_xpath.string('./@#{attr_name}', node)
    xmlAttribute(ret, :value) |> to_string
  end

  defp calculate_type(style, type) do
    stripped_style = Regex.replace(~r/(\"[^\"]*\"|\[[^\]]*\]|[\\_*].)/i, style, "")
    if Regex.match?(~r/[dmyhs]/i, stripped_style) do
      "date"
    else
      case {type, style} do
        {@shared_string_type, _} ->
          "shared_string"
        {@number_type, _} ->
          "number"
        {@boolean_type, _} ->
          "boolean"
        _ ->
          "string"
      end
    end
  end

  defp event({:startElement, _, 'row', _, _}, _, state) do
    Dict.put(state, :current_row, [])
  end

  defp event({:startElement, _, 'c', _, [_, {_, _, @shared_string_type, style}, {_, _, 't', type}]}, _, state) do
    { style_int, _ } = Integer.parse(to_string(style))
    style_content = elem(state.styles, style_int)
    type = calculate_type(style_content, type)
    Dict.put(state, :type, type)
  end

  defp event({:startElement, _, 'c', _, [_, _, {_, _, 't', 's'}]}, _, state) do
    Dict.put(state, :type, "string")
  end

  defp event({:endElement, _, 'c', _}, _, state) do
    Dict.delete(state, :type)
  end

  defp event({:startElement, _, 'v', _, _}, _, state) do
    Dict.put(state, :collect, true)
  end

  defp event({:startElement, _, 'f', _, _}, _, state) do
    Dict.put(state, :type, "boolean")
  end

  defp event({:endElement, _, 'v', _}, _, state) do
    Dict.put(state, :collect, false)
  end

  defp event({:characters, chars}, _, %{ collect: true, type: type } = state) do
    value = to_string(chars) |> Excellent.Type.from_string(%{type: type, lookup: state[:shared_strings]})

    %{
      state |
      current_row: [value|state[:current_row]]
    }
  end

  defp event({:endElement, _, 'row', _}, _, state) do
    %{
      state |
      content: [Enum.reverse(state[:current_row])|state[:content]]
    }
  end

  defp event(_, _, state) do
    state
  end
end
