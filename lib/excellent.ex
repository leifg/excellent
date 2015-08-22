defmodule Excellent do
  require Record

  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  def worksheet_names filename do
    {:ok, [{_filename, xml_content}] } = :zip.extract filename, [:memory, {:file_filter, fn(file) -> elem(file, 1) == 'xl/workbook.xml' end }]

    {xml, _rest} = :xmerl_scan.string(:erlang.binary_to_list(xml_content))
    :xmerl_xpath.string('/workbook/sheets/sheet/@name', xml) |> Enum.map(fn(x) -> elem(x, 8 ) end)
  end
end
