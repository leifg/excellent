defmodule Excellent do
  def parse filename, num_of_worksheet do
    file_content(filename, 'xl/worksheets/sheet#{num_of_worksheet + 1}.xml')
      |> Excellent.Parser.sax_parse_worksheet(shared_strings(filename), styles(filename))
  end

  def worksheet_names filename do
    file_content(filename, 'xl/workbook.xml')
      |> Excellent.Parser.parse_worksheet_names
  end

  def shared_strings(spreadsheet_filename) do
    file_content(spreadsheet_filename, 'xl/sharedStrings.xml')
      |> Excellent.Parser.parse_shared_strings
  end

  def styles(spreadsheet_filename) do
    file_content(spreadsheet_filename, 'xl/styles.xml')
      |> Excellent.Parser.parse_styles
  end

  defp file_content(spreadsheet_filename, inner_filename) do
    {:ok, [{_filename, file_content}]} = :zip.extract spreadsheet_filename, [:memory, {:file_filter, fn(file) -> elem(file, 1) == inner_filename end }]
    file_content
  end
end
